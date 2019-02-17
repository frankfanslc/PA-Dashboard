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

#Lendo Dataset
df=read.csv("/home/monica/Dropbox/IGTI/DISCIPLINAS/PROJETO APLICADO/TCC Disciplina/DESENVOLVIMENTO/MVPs/MVP 1/PA/ScriptsFinais/exit_entrance.csv", header = TRUE, sep = ",", quote = "", dec = ".")

#Agrupando por title
dataTableTitle <- data.table(df)
df3 <- df %>%  separate(pageTitle, c("pageTitle", "resto"), " \\|")
df3 <-  df3 %>% mutate_all(funs(toupper))
dataTableTitle$pageTitle <- df3$pageTitle
datasetFinal <- dataTableTitle[, list(entrances=sum(entrances), exits=sum(exits), pageviews=sum(pageviews)), by = list(pageTitle)]

newdata <- datasetFinal %>%
  arrange(pageviews) %>%
  mutate(pageTitle=factor(pageTitle, levels=pageTitle))

newdata <- newdata[order(-pageviews),] 
newdata <- dplyr::rename(newdata, "Entradas" = entrances)
newdata <- dplyr::rename(newdata, "Saídas" = exits)
newdata <- dplyr::rename(newdata, "Visuzalizações" = pageviews)

d <- melt(newdata, id.vars="pageTitle")

plot <- d %>%
  ggplot( aes(x=pageTitle, y=value, col=variable)) +
  geom_segment( aes(xend=pageTitle, yend=0)) +
  geom_point( size=2) +
  coord_flip() +
  labs(title = "Páginas de entrada e saída do site", subtitle = "Trimestre 2018", y = "", x = "", legend.title = element_blank())+
  theme(legend.title = element_blank())
  #+ theme_bw()
  #stat_smooth()
  #facet_wrap(~variable)
plot
ggsave("G8_entrances_exits.png", width = 30, height = 15, units = "cm")


# Reorder following the value of another column lollipop
#newdata %>%
#  arrange(pageviews) %>%
#  mutate(pageTitle=factor(pageTitle, levels=pageTitle)) %>%
#  ggplot( aes(x=pageTitle, y=pageviews)) +
#  geom_segment( aes(xend=pageTitle, yend=0)) +
#  geom_point( size=4, color="orange") +
#  coord_flip() +
#  labs(title = "Páginas mais visitadas do site", subtitle = "Trimestre 2018", y = "Visualizações de página", x = "")+
#  theme_bw()
#ggsave("G4_top_pages.png", width = 20, height = 15, units = "cm")
