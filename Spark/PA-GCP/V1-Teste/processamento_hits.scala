import com.google.cloud.hadoop.io.bigquery.BigQueryConfiguration
import com.google.cloud.hadoop.io.bigquery.BigQueryFileFormat
import com.google.cloud.hadoop.io.bigquery.GsonBigQueryInputFormat
import com.google.cloud.hadoop.io.bigquery.output.BigQueryOutputConfiguration
import com.google.cloud.hadoop.io.bigquery.output.IndirectBigQueryOutputFormat
import com.google.gson.JsonObject
import org.apache.hadoop.io.LongWritable
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat
import org.apache.spark.rdd.RDD
import spark.implicits._

/**
 * Assumes you have a spark context (sc) -- running from spark-shell REPL.
 * Marked as transient since configuration is not Serializable. This should 
 * only be necessary in spark-shell REPL.
 */
@transient
val conf = sc.hadoopConfiguration

/**
 * Input parameters 
 * @param projectId ID do projeto no GCP
 * @param bucket GCP Storage para armazenamento temporário
 * @param fullyQualifiedInputTableId Tabela do BigQuery com os dados de entrada
 */
val projectId = conf.get("fs.gs.project.id") //celtic-house-222820
val bucket = conf.get("fs.gs.system.bucket")
val fullyQualifiedInputTableId = projectId + ":GA_raw.hits_data"

/** 
 * Input configuration
 * Configurando o projeto, bucket e tabela de entrada
 */
conf.set(BigQueryConfiguration.PROJECT_ID_KEY, projectId)
conf.set(BigQueryConfiguration.GCS_BUCKET_KEY, bucket)
BigQueryConfiguration.configureBigQueryInput(conf, fullyQualifiedInputTableId)


/** 
 * Output parameters
 * @param outputTableId Tabela do BigQuery para salvar os dados processados
 * @param outputGcsPath Caminho do GCP Storage para armazenamento temporário (deletado após completar o job)
 */
val outputTableId = projectId + ":GA_raw.hits_processed_output"
val outputGcsPath = ("gs://" + bucket + "/hadoop/tmp/bigquery/hitsoutput")

/**
 * Output configuration
 * Deixa o BigQuery identificar o schema da tabela de saída automaticamente
 */
BigQueryOutputConfiguration.configureWithAutoSchema(
    conf,
    outputTableId,
    outputGcsPath,
    BigQueryFileFormat.NEWLINE_DELIMITED_JSON,
    classOf[TextOutputFormat[_,_]]
)

conf.set("mapreduce.job.outputformat.class", classOf[IndirectBigQueryOutputFormat[_,_]].getName)
conf.set(BigQueryConfiguration.OUTPUT_TABLE_WRITE_DISPOSITION_KEY, "WRITE_TRUNCATE")	// Truncate the table before writing output to allow multiple runs


/**
 * Mapper Funcions
 * Funções para conversão dos objetos em chave-valor
 */
def convertToTuple(record: JsonObject) : (String, Long) = {
  val clientId = record.get("clientId").getAsString
  val count = 0
  return (clientId, count)
}

def mapperPageViewsDay(record: JsonObject, numTotalHits : Long) : (String, Long) = {
  val clientId = record.get("clientId").getAsString
  val count = numTotalHits
  return (clientId, count)
}

def mapperClientID(record: JsonObject) : (String, Long) = {
  val clientId = record.get("clientId").getAsString
  val count = 1
  return (clientId, count)
}

def convertToJson(pair: (String, Long)) : JsonObject = {
  val clientId = pair._1
  val count = pair._2
  val jsonObject = new JsonObject()
  jsonObject.addProperty("clientId", clientId)
  jsonObject.addProperty("pageviews_day", count)
  return jsonObject
}

def convertToJsonOutput (
	originalPair: JsonObject, 
	//pageViewsByClientIDPair: (String, Long), 
	pageViewsDay: Long, 
	uniquePageViews: Long) : JsonObject = {
		
	val clientId = originalPair.get("clientId").getAsString
	val jsonObject = new JsonObject()
	jsonObject.addProperty("clientId", clientId)
	jsonObject.addProperty("pageviews_day", pageViewsDay)
	jsonObject.addProperty("unique_pageviews", uniquePageViews)
	//jsonObject.addProperty("user_pageviews", pageViewsByClientIDPair._2)
	println(jsonObject)
	return jsonObject
}

/*def getClientPageViews (pageViewsByClientIDRdd: org.apache.spark.rdd.RDD[(String, Long)], clientID: String ) : (String, Long) = {	
	//pageViewsByClientID.filter( cliente => cliente._1 == entry._2.get("clientId").getAsString ).first(),
	val tupla = pageViewsByClientIDRdd.filter( cliente => cliente._1 == clientID ).first()
	return tupla
}*/

/**
 * Entrada de dados 
 * Load data from BigQuery
 */
val tableDataRDD = sc.newAPIHadoopRDD(
    conf,
    classOf[GsonBigQueryInputFormat],
    classOf[LongWritable],
    classOf[JsonObject])

/*val wordCounts = (tableData
    .map(entry => convertToTuple(entry._2))
    .reduceByKey(_ + _))
*/

/**
 * Reducer Functions
 * Funções para a realização dos cálculos dos objetos
 */
 
/**Calculando o número de pageviews_day*/
//val pageViewsDayRDD = (tableDataRDD.map(entry => mapperPageViewsDay(entry._2, numLinhasRDD)))
val pageViewsDay = tableDataRDD.count()
println(pageViewsDay)

/**Calculando o número de unique_pageviews*/
val pageViewsByClientID = (tableDataRDD.map(entry => mapperClientID(entry._2)).reduceByKey(_ + _))
val pageViewsByClientRDD = pageViewsByClientID.map( cliente => cliente._1 == entry._2.get("clientId").getAsString ).first(),
val uniquePageViews = pageViewsByClientID.count()
println(uniquePageViews)

//println(pageViewsByClientID.filter( cliente => cliente._1 == "1136591379.1543269").top(1))





/**
 * Saída de Dados
 * Write data back into a new BigQuery table
 * IndirectBigQueryOutputFormat discards keys, so set key to null
 */
(tableDataRDD
	.map(
		entry => (
			null, 
			convertToJsonOutput(
				entry._2,
				//pageViewsByClientID.filter( cliente => cliente._1 == entry._2.get("clientId").getAsString ).first(),
				pageViewsDay,
				uniquePageViews
			)
		)
	)
	.saveAsNewAPIHadoopDataset(conf)
)
	
/*(pageViewsByClientID
    .map(pair => (null, convertToJson(pair)))
    .saveAsNewAPIHadoopDataset(conf))
    */
	
//hitsProcessedRDD.take(10).foreach(l => println(l))
/*(hitsProcessedRDD
    .map(pair => (null, convertToJson(pair)))
    .saveAsNewAPIHadoopDataset(conf))
*/
