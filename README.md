# PA-Dashboard
Projeto aplicado 



## DADOS COLETADOS

### Nome do campo				### Tipo ### Modo
*clientId									  STRING	NULLABLE
*type										    STRING	NULLABLE
*version									  STRING	NULLABLE
*tid										  	STRING	NULLABLE
*userId								  	  STRING	NULLABLE
*referer									  STRING	NULLABLE
*ip											    STRING	NULLABLE
*timestamp								  INTEGER	NULLABLE
*device									    RECORD	NULLABLE
*device. screenResolution	  STRING	NULLABLE
*device. viewPort					  STRING	NULLABLE
*device. encoding					  STRING	NULLABLE
*device. screenColors			  STRING	NULLABLE
*device. language					  STRING	NULLABLE
*device. javaEnabled			  BOOLEAN	NULLABLE
*device. flashVersion		  	STRING	NULLABLE
*device. userAgent					STRING	NULLABLE
*page										    RECORD	NULLABLE
*page.location							STRING	NULLABLE
*page.title								  STRING	NULLABLE
*page.pagePath						  STRING	NULLABLE
*page.hostname						  STRING	NULLABLE
*trafficSource							RECORD	NULLABLE
*trafficSource.referralPath STRING	NULLABLE
*trafficSource.campaign			STRING	NULLABLE
*trafficSource.source				STRING	NULLABLE
*trafficSource.medium				STRING	NULLABLE
*trafficSource.term					STRING	NULLABLE
*trafficSource.content			STRING	NULLABLE
*eventInfo								  RECORD	NULLABLE
*eventInfo.eventCategory		STRING	NULLABLE
*eventInfo.eventAction			STRING	NULLABLE
*eventInfo.eventLabel				STRING	NULLABLE
*eventInfo.eventValue				INTEGER	NULLABLE
*customDimensions					  RECORD	REPEATED
*customDimensions.index		  INTEGER	NULLABLE
*customDimensions.value	  	STRING	NULLABLE
*customMetrics						  RECORD	REPEATED
*customMetrics.index				INTEGER	NULLABLE
*customMetrics.value				STRING	NULLABLE



## CALCULAR

* Lista de sessões: agrupar linhas por clienteID e fazer o cálculo se é a mesma sessão ou uma nova e contar as sessões, listando apenas uma por cliente
* Tipo de usuário (novos ou recorrentes): como consultar isso no Hadoop e apenas entre os dados de um determinado site?
* Year, day, year, month, week: extrair esses dados do atributo Timestamp
* Listar o número de cada tipo de usuário para cada dia
* Calcular a duração da sessão por usuário
* Calcular a duração média da Sessão
* Calcular o número de pageviews por dia
* Calcular o número de pageviews por usuário
* Calcular o número médio de pageviews por usuário
* Calcular as metas (tempo de sessão e páginas visitadas) por usuário e uma taxa geral
* Calcular taxa de conversoes
* Calcular número de usuários por fonte de origem (social, organico, adWords)
* Calcular o número de entradas e saídas por página
* Calcular o número de visitas por termo de pesquisa
