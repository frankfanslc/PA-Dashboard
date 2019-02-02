import com.google.cloud.hadoop.io.bigquery.BigQueryConfiguration
import com.google.cloud.hadoop.io.bigquery.BigQueryFileFormat
import com.google.cloud.hadoop.io.bigquery.GsonBigQueryInputFormat
import com.google.cloud.hadoop.io.bigquery.output.BigQueryOutputConfiguration
import com.google.cloud.hadoop.io.bigquery.output.IndirectBigQueryOutputFormat
import com.google.gson.JsonObject
import org.apache.hadoop.io.LongWritable
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat

// Assumes you have a spark context (sc) -- running from spark-shell REPL.
// Marked as transient since configuration is not Serializable. This should
// only be necessary in spark-shell REPL.
@transient
val conf = sc.hadoopConfiguration

// Input parameters.
val projectId = conf.get("fs.gs.project.id") //celtic-house-222820
val bucket = conf.get("fs.gs.system.bucket")
val fullyQualifiedInputTableId = projectId + ":GA_raw.hits_data"

// Input configuration.
conf.set(BigQueryConfiguration.PROJECT_ID_KEY, projectId)
conf.set(BigQueryConfiguration.GCS_BUCKET_KEY, bucket)
BigQueryConfiguration.configureBigQueryInput(conf, fullyQualifiedInputTableId)


// Output parameters.
val outputTableId = projectId + ":GA_raw.hits_processed_output"

// Temp output bucket that is deleted upon completion of job.
val outputGcsPath = ("gs://" + bucket + "/hadoop/tmp/bigquery/hitsoutput")

// Output configuration.
// Let BigQuery auto-detect output schema (set to null below).
BigQueryOutputConfiguration.configureWithAutoSchema(
    conf,
    outputTableId,
    outputGcsPath,
    BigQueryFileFormat.NEWLINE_DELIMITED_JSON,
    classOf[TextOutputFormat[_,_]]
)

// (Optional) Configure the KMS key used to encrypt the output table.
//BigQueryOutputConfiguration.setKmsKeyName(conf, "projects/celtic-house-222820/locations/us-west1/keyRings/r1/cryptoKeys/k1");

conf.set("mapreduce.job.outputformat.class", classOf[IndirectBigQueryOutputFormat[_,_]].getName)

// Truncate the table before writing output to allow multiple runs.
conf.set(BigQueryConfiguration.OUTPUT_TABLE_WRITE_DISPOSITION_KEY, "WRITE_TRUNCATE")

/*Helper to convert JsonObjects to (word, count) tuples.
def convertToTuple(record: JsonObject) : (String, Long) = {
  val word = record.get("word").getAsString.toLowerCase
  val count = record.get("word_count").getAsLong
  return (word, count)
}*/

// Pageview, contar as linhas de hits do dia
def convertToTuple(record: JsonObject) : (String, Long) = {
  val clientId = record.get("clientId").getAsString
  val count = 0
  return (clientId, count)
}

// Pageview, contar as linhas de hits do dia
def convertToTupleInitialized(record: JsonObject, numTotalHits : Long) : (String, Long) = {
  val clientId = record.get("clientId").getAsString
  val count = numTotalHits
  return (clientId, count)
}

// Helper to convert (clientId, count) tuples to JsonObjects
def convertToJson(pair: (String, Long)) : JsonObject = {
  val clientId = pair._1
  val count = pair._2
  val jsonObject = new JsonObject()
  jsonObject.addProperty("clientId", clientId)
  jsonObject.addProperty("pageviews_day", count)
  return jsonObject
}

/* Helper to convert (word, count) tuples to JsonObjects.
def convertToJson(pair: (String, Long)) : JsonObject = {
  val word = pair._1
  val count = pair._2
  val jsonObject = new JsonObject()
  jsonObject.addProperty("word", word)
  jsonObject.addProperty("word_count", count)
  return jsonObject
}*/

// Load data from BigQuery.
val tableData = sc.newAPIHadoopRDD(
    conf,
    classOf[GsonBigQueryInputFormat],
    classOf[LongWritable],
    classOf[JsonObject])

// Perform word count.
/*val wordCounts = (tableData
    .map(entry => convertToTuple(entry._2))
    .reduceByKey(_ + _))
*/
//Contagem de linhas de hits (Pageviews_day)
val numLinhasRDD = tableData.count()

// Display results pageView_day
println(numLinhasRDD)
//val wordCountsTeste = (tableData.map(entry => convertToTuple(entry._2)))    
//wordCountsTeste.take(10).foreach(l => println(l))

var hitsProcessed = (tableData.map(entry => convertToTupleInitialized(entry._2, numLinhasRDD)))

// Display 10 results.
hitsProcessed.take(10).foreach(l => println(l))

// Display 10 results.
//wordCounts.take(10).foreach(l => println(l))



// Write data back into a new BigQuery table.
// IndirectBigQueryOutputFormat discards keys, so set key to null.
/*(wordCounts
    .map(pair => (null, convertToJson(pair)))
    .saveAsNewAPIHadoopDataset(conf))
*/

// Write data back into a new BigQuery table.
// IndirectBigQueryOutputFormat discards keys, so set key to null.
(hitsProcessed
    .map(pair => (null, convertToJson(pair)))
    .saveAsNewAPIHadoopDataset(conf))

