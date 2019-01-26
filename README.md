# Projeto aplicado - Web Analytics Dashboard
Reporting interface that allows you to monitor your website performance by tracking metrics like visitors, pageviews, and online conversions.

Desenvolvimento de uma aplicação que obtenha os dados de hits de diversos sites
(instituicionais, blogs e lojas virtuais) dos cliente de uma agência, armazene, 
processe e exiba-os em uma interface intuitiva que permita a obtenção de insights 
individualmente por cliente e de forma geral, como uma métrica de resultados da 
agência.

## MÓDULOS

* streaming_hits			Codigo usado para realizar o streaming de raw hits para o BigQuery
* Hadoop/WordCountGCP2 		Exemplo de WordCount usando o GCP
* Hadoop/WordCountHadoop	Exemplo de WordCount básico
* Spark/WordCountExemploGCP Exemplo de WordCount usando o GCP
* Spark/PA-GCP				Processamento dos dados dos Hits coletados dos websites monitorados




## DADOS COLETADOS

## Nome do campo				  ## Tipo ## Modo

* clientId									  STRING	NULLABLE
* type										    STRING	NULLABLE
* version									    STRING	NULLABLE
* tid										  	  STRING	NULLABLE
* userId								  	  STRING	NULLABLE
* referer									    STRING	NULLABLE
* ip											    STRING	NULLABLE
* timestamp								    INTEGER	NULLABLE
* device									    RECORD	NULLABLE
* device. screenResolution	  STRING	NULLABLE
* device. viewPort					  STRING	NULLABLE
* device. encoding					  STRING	NULLABLE
* device. screenColors			  STRING	NULLABLE
* device. language					  STRING	NULLABLE
* device. javaEnabled			    BOOLEAN	NULLABLE
* device. flashVersion		  	STRING	NULLABLE
* device. userAgent					  STRING	NULLABLE
* page										    RECORD	NULLABLE
* page.location							  STRING	NULLABLE
* page.title								  STRING	NULLABLE
* page.pagePath						    STRING	NULLABLE
* page.hostname						    STRING	NULLABLE
* trafficSource							  RECORD	NULLABLE
* trafficSource.referralPath  STRING	NULLABLE
* trafficSource.campaign			STRING	NULLABLE
* trafficSource.source				STRING	NULLABLE
* trafficSource.medium				STRING	NULLABLE
* trafficSource.term					STRING	NULLABLE
* trafficSource.content			  STRING	NULLABLE
* eventInfo								    RECORD	NULLABLE
* eventInfo.eventCategory		  STRING	NULLABLE
* eventInfo.eventAction			  STRING	NULLABLE
* eventInfo.eventLabel				STRING	NULLABLE
* eventInfo.eventValue				INTEGER	NULLABLE
* customDimensions					  RECORD	REPEATED
* customDimensions.index		  INTEGER	NULLABLE
* customDimensions.value	  	STRING	NULLABLE
* customMetrics						    RECORD	REPEATED
* customMetrics.index				  INTEGER	NULLABLE
* customMetrics.value				  STRING	NULLABLE



## CALCULAR DIARIAMENTE

* Extrair Year, day, year, month, week do atributo Timestamp
* Calcular a duração da sessão por usuário (max - min) baseado em timestamp
* Calcular a duração média da Sessão (valor único)
* Calcular o número de pageviews por usuário 
* Calcular o número de pageviews por dia (valor único)
* Calcular o número médio de pageviews (valor único)
* Calcular as metas (tempo de sessão e páginas visitadas) por usuário
* Calcular as metas (tempo de sessão e páginas visitadas) completadas (somatório)
* Calcular taxa de conversões de metas (valor único)
* Calcular número de usuários por fonte de origem (social, organico, adWords)


## EXTRAS

* Lista de sessões: agrupar linhas por clienteID e fazer o cálculo se é a mesma sessão ou uma nova e contar as sessões
* Tipo de usuário (novos ou recorrentes)
* Listar o número de cada tipo de usuário para cada dia
* Calcular o número de entradas e saídas por página (baseado no timestamp e clientID)
* Calcular o número de visitas por termo de pesquisa
