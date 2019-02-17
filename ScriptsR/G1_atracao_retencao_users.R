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
df=read.csv("1_1.csv", header = TRUE, sep = ",", quote = "", dec = ".")
meses <- c("Jan","Feb","Mar", "Abr","Mai","Jun", "Jul","Ago","Set", "Out","Nov","Dez")
  
#Transformacoes
df$date <- as.Date( df$date, '%d/%m/%Y')
df$month <- meses[ df$month ]

#Obtendo weeks atraves das datas
dataWeeksData <- data.frame(df, Week = format(df$date, format = "%W"))

#Agrupando por weeks
dataTableWeeks = data.table(dataWeeksData)
datasetFinal <- dataTableWeeks[, list(date, users=sum(users), newusers=sum(newusers)), by = list(Week, usertype, month)]

#Merge colunas usertype
newVisitors <- filter(datasetFinal, grepl('New Visitor', usertype))
newVisitorsByWeek <- newVisitors[match(unique(newVisitors$Week), newVisitors$Week),]

returningVisitors <- filter(datasetFinal, grepl('Returning Visitor', usertype))
returningVisitorsByWeek <- returningVisitors[match(unique(returningVisitors$Week), returningVisitors$Week),]

newVisitorsByWeek$users <- returningVisitorsByWeek$users
datasetFinal <- newVisitorsByWeek

#Grafico 1: tipo de usuarios por semana
df2 = subset(datasetFinal, select=c(date, users , newusers))
df2 <- dplyr::rename(df2, "Novos usuários" = newusers)
df2 <- dplyr::rename(df2, "Usuários Recorrentes" = users)

test_data_long <- melt(df2, id="date")  # convert to long format
ggplot(data=test_data_long,  aes(x=date, y=value, colour=variable)) + geom_line() +geom_point()+ labs(title = "Atração e Retenção de usuários", subtitle = "Trimestre 2018", y = "Número de usuários", x = "")+theme(legend.position=c(0.5, 0.94), legend.title = element_blank())
ggsave("G1_Users.png")
