rm(list=ls())
cons<-dbListConnections(MySQL()) 
for(con in cons) {dbDisconnect(con)}

t1=Sys.time()

# Chargement des librairies nécessaires

library(RMySQL)
library(tidyr)
library(dplyr)
#Extraction des donné