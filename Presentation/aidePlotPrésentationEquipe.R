dataQuality <-c()
WD <- '/home/charriat/Documents/stage/StatQuality'
file.quality <- file.path(WD,'allStatQuality')
dataQ <- read.table(file=file.quality, sep="\t", header=TRUE)
idS <- c()
idSouche <- c()
for (i in 1:nrow(dataQ))
{
  idS<- toString(dataQ[i,11])
  idSouche <- c(idSouche,substr(idS,0,9))
}
dataQ[,11] <- idSouche
dataQuality <-dataQ[,1:10]
rownames(dataQuality) <- idSouche
kmère <- c(20,30,40,50,60,70,80,90)
Id <- c()
j <- 1
N50 <- data.frame(matrix(NA,ncol=length(kmère),nrow = (nrow(dataQuality)/8)))
for (i in 1:(nrow(dataQuality)/8))
{
  Ids <- rownames(dataQuality[i*8,])
  Id <- c(Id,substr(Ids,0,6))
  N50[i,] <- dataQuality[j:(i*8),6]
  j <- i*8+1
}
rownames(N50) <- Id
colnames(N50) <- kmère

################ Selection ############################
selection <- data.frame(matrix(NA,ncol= ncol(dataQuality) ,nrow = (nrow(dataQuality)/8)))
id.select <- c()
for (i in 1:nrow(N50))
{
  bestKmer <- colnames(N50[i,])[which(N50[i,] == max(N50[i,]), arr.ind = TRUE)[2]]
  newId <- paste(rownames(N50[i,]),toString(bestKmer),sep = '_')
  id.select <- c(id.select,newId)
  selection[i,] <-  dataQuality[rownames(dataQuality) == newId,]
  
}
colnames(selection) <- colnames(dataQuality)
rownames(selection) <- id.select
dataQuality <- dataQuality[(40*8+1):nrow(dataQuality),]
x.kmère <- c()
for (i in 1:(nrow(dataQuality)/8))
{
  x.kmère <- c(x.kmère,rep(i,8))
}
select.kmère <- c()
for (i in 1:nrow(dataQuality))
{
  if (rownames(dataQuality[i,]) %in% id.select)
  {
    select.kmère <- c(select.kmère, TRUE)
  }
  else 
  {
    select.kmère <- c(select.kmère, FALSE)
  }
}

######## Affichage plot #########
N50max <- 25000 # Selection des assemblage avec un N50 supérieur à 25 000

par(mfrow=c(2,2))
plot(x = x.kmère, y = dataQuality$N50, ylab ='N50',xlab = 'Souche', xaxt="n" , main ='Graphique n°1 : Visualisation du N50\n de tous les assemblages', cex = 0.3)
points(x = x.kmère[select.kmère], y = dataQuality$N50[select.kmère], cex = 0.4, col = 'red')
abline(h=N50max,col="red")
plot(x = x.kmère, y = dataQuality$L50, ylab ='L50', xlab = 'Souche', xaxt="n" , main ='Graphique n°1 : Visualisation du L50\n de tous les assemblage', cex = 0.3)
points(x = x.kmère[select.kmère], y = dataQuality$L50[select.kmère], cex = 0.4, col = 'red')
plot(x = x.kmère, y = dataQuality$max,ylab ='max',xlab = 'Souche', xaxt="n" , main ='Graphique n°3 : Visualisation\n de la longueur max des contigs de tous les assemblagela longueur max des contigs', cex = 0.3)
points(x = x.kmère[select.kmère], y = dataQuality$max[select.kmère], cex = 0.4, col = 'red')
plot(x = x.kmère, y = dataQuality$n.500,ylab ='n.500',xlab = 'Souche', xaxt="n" , main ='Graphique n°4 : Visualisation\n du nombre de contigs supérieur à 500 de tous les assemblage' , cex = 0.3)
points(x = x.kmère[select.kmère], y = dataQuality$n.500[select.kmère], cex = 0.4, col = 'red')



##########distribution longeur et GC ###############################

data <- read.table('Documents/stage/StatQuality/stat_repeatMasker', header = T, sep  = '\t')
plotLen <- ggplot(data, aes(x=Longueur.total)) + ggtitle("Distribution des longeurs de séquence\n de toutes les assemblages séléctionnés")+labs(x = "Longeur total de l'assemblage (mb)", y = 'Densité')+
  geom_density(alpha=.2, fill="steelblue") + theme(axis.text.y = element_blank())
plotLen

plotMas <- ggplot(data, aes(x=Pourcentage.bases.masquées)) + ggtitle("Distribution de la proportion d'éléments masqués\n de toutes les assemblages séléctionnés")+labs(x = "% de nucléotide masquée", y = 'Densité')+
  geom_density(alpha=.2, fill="steelblue") + theme(axis.text.y = element_blank()))
plotMas 
















