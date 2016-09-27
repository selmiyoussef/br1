# Récupération de la date et temps système


rm(list=ls())
cons<-dbListConnections(MySQL()) 
for(con in cons) {dbDisconnect(con)}

t1=Sys.time()