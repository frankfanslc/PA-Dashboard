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
df=read.csv("exit_entrance.csv", header = TRUE, sep = ",", quote = "", dec = ".")

#Agrupando por title
dataTableTitle <- data.table(df)
df3 <- df %>%  separate(pageTitle, c("pageTitle", "resto"), " \\|")
df3 <-  df3 %>% mutate_all(funs(toupper))
dataTableTitle$pageTitle <- df3$pageTitle
datasetFinal <- dataTableTitle[, list(entrances=sum(entrances), exits=sum(exits), pageviews=sum(pageviews)), by = list(pageTitle)]
newdata <- datasetFinal[order(-pageviews),] 

# Library
library(tidyverse)

# Create data
value1=abs(rnorm(26))*2
data=data.frame(x=LETTERS[1:26], value1=value1, value2=value1+1+rnorm(26, sd=1) )

# Reorder data using average?
newdata = newdata %>% rowwise() %>% mutate( mymean = mean(c(value1,value2) )) %>% arrange(mymean) %>% mutate(x=factor(x, x))

newdata <- newdata %>% arrange(pageviews) %>%
  mutate(Avg = mean(pageviews, na.rm = TRUE),
         Above = ifelse(entrances - exits > 0, TRUE, FALSE),
         county = factor(pageTitle, levels = .$pageTitle))

# plot
ggplot(newdata) +
  geom_segment( aes(x=pageTitle, xend=pageTitle, y=entrances, yend=exits), color="grey") +
  geom_point( aes(x=pageTitle, y=entrances), color=rgb(0.2,0.7,0.1,0.5), size=3 ) +
  geom_point( aes(x=pageTitle, y=exits), color=rgb(0.7,0.2,0.1,0.5), size=3 ) +
  coord_flip() +
  theme(  legend.position = "bottom")+
  labs(title = "Páginas de entrada e Saída dos usuários", subtitle = "Trimestre 2018")+
  xlab("") +
  ylab("Número de entradas e saídas ")



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
