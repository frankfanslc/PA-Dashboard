library(zoo)
library(dplyr)
library(plyr)
library(Lahman)
library(data.table)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
require(scales)
library(forcats)
library(stringr)
library(tidyr)
library(wordcloud)

#Lendo Dataset
df=read.csv("/home/monica/Dropbox/IGTI/DISCIPLINAS/PROJETO APLICADO/TCC Disciplina/DESENVOLVIMENTO/MVPs/MVP 1/PA/ScriptsFinais/query_terms.csv", header = TRUE, sep = ",", quote = "", dec = ".")
#df=read.csv("G9_termos_de_pesquisa.csv", header = TRUE, sep = ",", quote = "", dec = ".")

#grafico cliques
pal2 <- brewer.pal(8,"Dark2")
png("cliques_termos.png", width=1000,height=1000)
wordcloud(df$termos,df$cliques, scale=c(8,.4),min.freq=1, max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()

#grafico impressoes
pal2 <- brewer.pal(8,"Dark2")
png("impressoes_termos.png", width=1000,height=1000)
png("impressoes_termos.png")
wordcloud(df$termos,df$impressoes, scale=c(8,.4),min.freq=1, max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)
dev.off()