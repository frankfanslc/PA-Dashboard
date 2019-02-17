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
df=read.csv("g5_goals.csv", header = TRUE, sep = ",", quote = "", dec = ".")
meses <- c("Jan","Feb","Mar", "Abr","Mai","Jun", "Jul","Ago","Set", "Out","Nov","Dez")

#Transformacoes
df$date <- as.Date( df$date, '%d/%m/%Y')
df$month <- meses[ df$month ]

#Agrupando por weeks
dataTableWeeks = data.table(df)
datasetFinal <- dataTableWeeks[, list(date, sessions=sum(sessions), goal1=sum(goal1), goal2=sum(goal2), goal3=sum(goal3), goal4=sum(goal4), soma_metas_completadas=sum(soma_metas_completadas)), by = list(week, month)]

#Obtendo primeira data da semana
datasetFinal <- datasetFinal[match(unique(datasetFinal$week), datasetFinal$week),]



#Grafico 1: sessoes e taxa de rejeicao
df2 = subset(datasetFinal, select=c(date, goal1 , goal2, goal3, goal4))
df2 <- dplyr::rename(df2, "Meta1" = goal1)
df2 <- dplyr::rename(df2, "Meta2" = goal2)
df2 <- dplyr::rename(df2, "Meta3" = goal3)
df2 <- dplyr::rename(df2, "Meta4" = goal4)

test_data_long <- melt(df2, id="date")  # convert to long format
ggplot(data=test_data_long,  aes(x=date, y=value, colour=variable,  linetype = variable)) +
  geom_line() +
  geom_point() +
  labs(title = "Desempenho das Metas do Site", subtitle = "2018", y = "Número de Sessões", x = "")+
  theme(legend.position="bottom", legend.title = element_blank())
ggsave("G5_metas.png")
