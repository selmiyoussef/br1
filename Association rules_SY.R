###################################################################
  
 ##################SELMI YOUSSEF (2015). 


  ######title = Association rules
    ####author = {SELMI YOUSSEF},
    ####year = {2015},
    ####note = {Digital Marketing },
  ########################################################################






T1=Sys.time()

# Chargement des librairies nécessaires

library(RMySQL)
library("arules");
library(plyr)


mydb2 = dbConnect(MySQL(), user='root', password='pswd', dbname='name_database', host='ip_serveur')
dbGetQuery(mydb2, "SET NAMES 'utf8'")

 rs=dbSendQuery(mydb2, 'SELECT os.id_order_site, sp.id_product_site, sop.product_name
               FROM sp_site_order os
               LEFT JOIN sp_site_order_product sop ON (sop.id_order = os.id)
               LEFT JOIN sp_site_product sp ON (sop.id_product = sp.id_product)
               WHERE sp.id_product_site <> 0
               AND sp.active = 1
               )

request = fetch(rs,n=-1)

#voir capture_bd.jpg

dbClearResult(dbListResults(mydb2)[[1]])

names(request)=c("order","id_pd","name")

req=request[-c(3)]

library(data.table)
req <- data.table(req)
req=req[,paste(id_pd,collapse=","), by = order]
req=as.data.frame(req$V1) 
names(req)="panier_commande"

write.table(req, file = "transactions.csv", sep = ",",col.names = FALSE, row.names = FALSE, quote = FALSE)

tr <- read.transactions("transactions.csv", format = "basket", sep=',',rm.duplicates= TRUE)

basket_rules <- apriori(tr,parameter = list(sup = 0.0002, conf =0.6,minlen=2,target="rules"), appearance = list(default = "both"));

#inspect(basket_rules);

rules.sorted <- sort(basket_rules, by="lift")

### les doubles regles
subset.matrix <- is.subset(rules.sorted, rules.sorted)
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
redundant <- colSums(subset.matrix, na.rm=T) >= 1

# supprimer ces doublons
rules.pruned <- rules.sorted[!redundant]

##Frequence_items_panier

itemsets <- unique(generatingItemsets(rules.pruned))
##nombre de paniers et edit
#itemsets
#inspect(itemsets)
itemsets.df <- as(itemsets, "data.frame")
frequentItemsets <- itemsets.df[with(itemsets.df, order(-support,items)),]
names(frequentItemsets)[1] <- "panier"

write.table(frequentItemsets, file = "export.csv", sep = ",", row.names = FALSE)

#Connexion à la base de données

mydb_pack = dbConnect(MySQL(), user='root', password='pswd', dbname='name_database', host='Ip')

#Récupérer id_site






dbWriteTable(mydb_pack, name='pack', value=frequentItemsets,row.names=FALSE, append = TRUE)


#Close connexion

dbDisconnect(mydb_pack)

dbDisconnect(mydb2)

# Calculer le temps d'exécution

Sys.time()-T1
