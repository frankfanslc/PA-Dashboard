library(zoo)
library(dplyr)
library(plyr)
library(Lahman)
library(data.table)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
require(scales)

#Lendo Dataset
df=read.csv("2bounce.csv", header = TRUE, sep = ",", quote = "", dec = ".")
meses <- c("Jan","Feb","Mar", "Abr","Mai","Jun", "Jul","Ago","Set", "Out","Nov","Dez")

#Transformacoes
df$date <- as.Date( df$date, '%d/%m/%Y')
df$month <- meses[ df$month ]
df <- mutate(df, diferenca = sessions - bounces)

#Agrupando por weeks
dataTableWeeks = data.table(df)
datasetFinal <- dataTableWeeks[, list(date, sessions=sum(sessions), bounces=sum(bounces), sessionDuration=sum(sessionDuration), avgSessionDuration=sum(avgSessionDuration) , diferenca=sum(diferenca)), by = list(week, month)]

#Obtendo primeira data da semana
datasetFinal <- datasetFinal[match(unique(datasetFinal$week), datasetFinal$week),]



#Grafico 1: sessoes e taxa de rejeicao
#df2 = subset(datasetFinal, select=c(date, sessions , bounces, diferenca))
#df2 <- dplyr::rename(df2, "Sessões" = sessions)
#df2 <- dplyr::rename(df2, "Sessões de apenas uma pág." = bounces)
#df2 <- dplyr::rename(df2, "Sessões de mais de uma pág." = diferenca)

#test_data_long <- melt(df2, id="date")  # convert to long format
#ggplot(data=test_data_long,  aes(x=date, y=value, colour=variable,  linetype = variable)) +geom_line() +geom_point() +labs(title = "Engajamento e atratividade dos usuários pelo site", subtitle = "Trimestre 2018", y = "Número de sessões", x = "")+theme(legend.position="bottom", legend.title = element_blank())
#ggsave("G2_bounce.png")

#Tempo de sessao avg
sessionDurationSD <- ddply(df,~week,summarise,mean=mean(avgSessionDuration),sd=sd(avgSessionDuration))
sessionDurationSD2 <- ddply(df,~week,summarise,mean=mean(sessionDuration),sd=sd(sessionDuration))

datasetFinal$sdSessionDuration <-sessionDurationSD$sd
datasetFinal$meanSessionDuration <-sessionDurationSD$mean


#Grafico 2: tempo de sessao 
df2 = subset(datasetFinal, select=c(date, meanSessionDuration, avgSessionDuration, sdSessionDuration))
# <- dplyr::rename(df2, "Duração das sessões" = sessionDuration)
#df2 <- dplyr::rename(df2, "Duração média das sessões" = meanSessionDuration)
#df2 <- dplyr::rename(df2, "Sessões de mais de uma pág." = diferenca)

test_data_long <- melt(df2, id="date")  # convert to long format
pd <- position_dodge(0.1) # move them .05 to the left and right
ggplot(data=df2,  aes(x=date, y=avgSessionDuration))+geom_errorbar(aes(ymin=avgSessionDuration-sdSessionDuration, ymax=avgSessionDuration+sdSessionDuration), width=.1) +geom_line(position=pd) +geom_point(position=pd) +labs(title = "Engajamento e atratividade dos usuários pelo site", subtitle = "Trimestre 2018", y = "Número de sessões", x = "")+theme(legend.position="bottom", legend.title = element_blank())
ggsave("G3_session_duration.png")
