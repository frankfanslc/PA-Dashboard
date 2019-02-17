library(zoo)
library(dplyr)
library(plyr)
library(Lahman)
library(data.table)
library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(stringr)

#Lendo Dataset
df=read.csv("G7_referall.csv", header = TRUE, sep = ",", quote = "", dec = ".", stringsAsFactors = FALSE)

#transformacoes
for(val in 1:length(df$socialNetwork)){
  if (df$socialNetwork[val] %in% c("(not set)")){
    df$socialNetwork[val] <- df$channelGrouping[val]
  }
}

#agrupando
dataTableSocial = data.table(df)
dataTableSocial <- dataTableSocial[, list(users=sum(users)), by = list(socialNetwork)]

#Grafico 1: sessoes e taxa de rejeicao
df2 = subset(dataTableSocial, select=c(users, socialNetwork))

blank_theme <- theme_minimal()+
  theme(
    axis.title.x =  element_blank(),
    axis.title.y =  element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    legend.title = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

bp<- ggplot(df2, aes(x="", y=users, fill=socialNetwork))+
  geom_bar(width = 1, stat = "identity")+
  blank_theme +
  labs(title = "Usuários por Fontes do Tráfego", subtitle = "2018")+
  scale_fill_brewer(palette="Dark2")
bp
ggsave("G5_referall.png")

#pie +  blank_theme +
#  theme(axis.text.x=element_blank()) +
# geom_text(aes(y = users/6 + c(0, cumsum(users)[-length(users)]), 
#                label = percent(users/100)), size=2)

#pie <- bp + coord_polar("y", start=0)+theme_minimal()
#  theme(axis.text.x=element_blank(), legend.title = element_blank()) +
#  labs(title = "Fontes do Tráfego", subtitle = "2018")+
#  geom_text(aes(y = users/6 + c(0, cumsum(users)[-length(users)]), label = percent(users/100)), size=3)
#pie
#ggsave("G5_referall.png")
