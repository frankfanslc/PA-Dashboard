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
df=read.csv("top_pages.csv", header = TRUE, sep = ",", quote = "", dec = ".")

#Agrupando por title
dataTableTitle <- data.table(df)
df3 <- df %>%  separate(pageTitle, c("pageTitle", "resto"), " \\|")
df3 <-  df3 %>% mutate_all(funs(toupper))
dataTableTitle$pageTitle <- df3$pageTitle
datasetFinal <- dataTableTitle[, list(pageviews=sum(pageviews)), by = list(pageTitle)]
newdata <- datasetFinal[order(-pageviews),] 


# Reorder following the value of another column lollipop
newdata[1:10, drop=FALSE] %>%
  arrange(pageviews) %>%
  mutate(pageTitle=factor(pageTitle, levels=pageTitle)) %>%
  ggplot( aes(x=pageTitle, y=pageviews)) +
  geom_segment( aes(xend=pageTitle, yend=0)) +
  geom_point( size=4, color="orange") +
  coord_flip() +
  labs(title = "Páginas mais visitadas do site", subtitle = "Trimestre 2018", y = "Visualizações de página", x = "")+
  theme_bw()
ggsave("G4_top_pages.png", width = 20, height = 15, units = "cm")


#Barplot
# Reorder following the value of another column:
#newdata %>%
#  mutate(pageTitle = fct_reorder(pageTitle, pageviews)) %>%
#  ggplot( aes(x=pageTitle, y=pageviews)) +
#  geom_bar(stat="identity")+
#  labs(title = "Páginas mais visitadas do site", subtitle = "Trimestre 2018", y = "Visualizações de página", x = "")+
#  coord_flip()
