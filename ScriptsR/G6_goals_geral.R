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
df=read.csv("g6_meta_taxa.csv", header = TRUE, sep = ",", quote = "", dec = ".")
meses <- c("Jan","Feb","Mar", "Abr","Mai","Jun", "Jul","Ago","Set", "Out","Nov","Dez")

#Transformacoes
df$date <- as.Date( df$date, '%d/%m/%Y')
df$month <- meses[ df$month ]

#Agrupando por weeks
dataTableWeeks = data.table(df)
datasetFinal <- dataTableWeeks[, list(date, sessions=sum(sessions), goalCompletionsAll=sum(goalCompletionsAll)), by = list(week, month)]

#Obtendo primeira data da semana
datasetFinal <- datasetFinal[match(unique(datasetFinal$week), datasetFinal$week),]

#Grafico 1: sessoes e taxa de rejeicao
df2 = subset(datasetFinal, select=c(date, sessions, goalCompletionsAll))
df2 <- dplyr::rename(df2, "Sessões" = sessions)
df2 <- dplyr::rename(df2, "Total de Metas Completadas" = goalCompletionsAll)

test_data_long <- melt(df2, id="date")  # convert to long format
ggplot(data=test_data_long,  aes(x=date, y=value, colour=variable,  linetype = variable)) +
  geom_line() +
  geom_point() +
  labs(title = "Desempenho das Metas do Site", subtitle = "2018", y = "Número de Sessões", x = "")+
  theme(legend.position="bottom", legend.title = element_blank())
ggsave("G5_metas_taxa.png")
