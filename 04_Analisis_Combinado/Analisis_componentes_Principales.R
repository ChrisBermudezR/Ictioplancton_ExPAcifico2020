#Título del script: Análisis de Componentes principales, MRPP y Correlaciones de los datos fisicoquímicos.
#Autores: Christian Bermúdez-Rivas 
#Objetivo: Realizar los análisis de los datos fisico químicos.
#Lenguaje: R
#Fecha: Junio 2022
#Notas: No olvidar instalar los paquetes necesarios para correr el script
###############################################################################################################################



#library(Rcpp)
install.packages("factoextra")
library(gridExtra)
library(ggplot2)
library(factoextra)
library(corrplot)
library(psych)

datos_CCCP<-read.csv("./01_Datos/Datos_Totales_CCCP.csv")





#Separar la matriz de variables
data_completo_CCCP<-datos_CCCP[,12:31]
#dar nombres a las filas utilizando el codigo para las estaciones en cada tipo de marea
rownames(data_completo_CCCP)<-datos_CCCP$Codigo   


#Calcular los componentes principales
data_completo_CCCP.pca <- prcomp(na.omit(data_completo_CCCP), scale = TRUE)
print(data_completo_CCCP.pca)
summary(data_completo_CCCP.pca)
Comp_var<-as.data.frame(data_completo_CCCP.pca[5])
colnames(Comp_var)<-c("PC01", "PC02", 
                      "PC03", "PC04", 
                      "PC05", "PC06", 
                      "PC07","PC08", 
                      "PC09", "PC10", 
                      "PC11", "PC12", 
                      "PC13", "PC14",
                      "PC15", "PC16", 
                      "PC17", "PC18",
                      "PC19", "PC20"
                      
)
#exportar los valores de los residuales del cáculo de los componentes
write.table(Comp_var, "Componentes_principales_valores_Var_CCCP.csv", dec = ".", sep=",", row.names = TRUE)


######Gráficas de los componentes principales#####

var <-get_pca_var(data_completo_CCCP.pca)
#Gráfica de correlación entre lasvariables y los componentes
var$cos2

contribucion<-as.data.frame(var[["contrib"]])

sort.list(as.data.frame(contribucion[,1]),  decreasing = TRUE,
          partial = NULL,    # Vector de índices para ordenado parcial
          na.last = TRUE)

png(filename = "./02_Imagenes/PCA_CCCP_COR.png",width = 20, height = 20, units = "cm", res=300, pointsize = 0.1)
corrplot(var$cor, is.corr=TRUE)
dev.off()

graf01<-factoextra::fviz_eig(data_completo_CCCP.pca,addlabels = TRUE,hjust = -0.3,linecolor ="red")+
  labs(title="PCA - Screeplot",x="Dimensiones (PC)", y="% explicado de var.")+
  ylim(c(0,65))



PCA_12<-factoextra::fviz_pca_biplot(data_completo_CCCP.pca, repel = TRUE,
                                    axes = c(1,2),
                                    col.var = "#2E9FDF", # Variables color
                                    col.ind = "#696969"  # Individuals color
)+
  labs(x="PC1 (45.3%)", y="PC2 (17.5%)")

PCA_23<-factoextra::fviz_pca_biplot(data_completo_CCCP.pca, repel = TRUE,
                                    axes = c(2,3),
                                    col.var = "#2E9FDF", # Variables color
                                    col.ind = "#696969"  # Individuals color
)+
  labs(x="PC2 (17.5%)", y="PC3 (9%)")


Marea <- as.factor(datos_CCCP$Marea)
PCA_12_marea<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                       axes = c(1,2),
                                       col.ind = Marea, # color by groups
                                       palette = c("#00AFBB",  "#FC4E07"),
                                       addEllipses = TRUE, # Concentration ellipses
                                       ellipse.type = "confidence",
                                       legend.title = "Groups",
                                       repel = TRUE
)+
  labs(title="PCA - Agrupado por mareas",x="PC1 (45.3%)", y="PC2 (17.5%)")

PCA_23_marea<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                       axes = c(2,3),
                                       col.ind = Marea, # color by groups
                                       palette = c("#00AFBB",  "#FC4E07"),
                                       addEllipses = TRUE, # Concentration ellipses
                                       ellipse.type = "confidence",
                                       legend.title = "Groups",
                                       repel = TRUE
)+
  labs(title="PCA - Agrupado por mareas",x="PC2 (17.5%)", y="PC3 (9%)")



Transecto <- as.factor(datos_CCCP$Transecto)


PCA_12_Transecto<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                       axes = c(1,2),
                                       col.ind = Transecto, # color by groups
                                       palette = c("#00AFBB",  "#FC4E07", "grey"),
                                       addEllipses = TRUE, # Concentration ellipses
                                       ellipse.type = "confidence",
                                       legend.title = "Groups",
                                       repel = TRUE
)+
  labs(title="PCA - Agrupado por transectos",x="PC1 (45.3%)", y="PC2 (17.5%)")

PCA_23_Transecto<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                       axes = c(2,3),
                                       col.ind = Transecto, # color by groups
                                       palette = c("#00AFBB",  "#FC4E07", "grey"),
                                       addEllipses = TRUE, # Concentration ellipses
                                       ellipse.type = "confidence",
                                       legend.title = "Groups",
                                       repel = TRUE
)+
  labs(title="PCA - Agrupado por transectos",x="PC2 (17.5%)", y="PC3 (9%)")





Sector <- as.factor(datos_CCCP$Sector)


PCA_12_Sector<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                           axes = c(1,2),
                                           col.ind = Sector, # color by groups
                                           palette = c("#00AFBB",  "#FC4E07", "grey", "blue", "black","green"),
                                           addEllipses = TRUE, # Concentration ellipses
                                           ellipse.type = "confidence",
                                           legend.title = "Groups",
                                           repel = TRUE
)+
  labs(title="PCA - Agrupado por sector",x="PC1 (45.3%)", y="PC2 (17.5%)")

PCA_23_Sector<-factoextra::fviz_pca_ind(data_completo_CCCP.pca,
                                           axes = c(2,3),
                                           col.ind = Sector, # color by groups
                                           palette = c("#00AFBB",  "#FC4E07", "grey", "blue", "black","green"),
                                           addEllipses = TRUE, # Concentration ellipses
                                           ellipse.type = "confidence",
                                           legend.title = "Groups",
                                           repel = TRUE
)+
  labs(title="PCA - Agrupado por sector",x="PC2 (17.5%)", y="PC3 (9%)")


png(filename = "./02_Imagenes/PCA_CCCP01.png",width = 20, height = 30, units = "cm", res=300, pointsize = 0.1)
grid.arrange(arrangeGrob(graf01),
             arrangeGrob(PCA_12, PCA_23, ncol = 2),
             ncol=1)
dev.off()


png(filename = "./02_Imagenes/PCA_CCCP02.png",width = 20, height = 30, units = "cm", res=300, pointsize = 0.1)
grid.arrange(arrangeGrob(PCA_12_marea,PCA_23_marea, ncol = 2),
             arrangeGrob(PCA_12_Transecto,PCA_23_Transecto, ncol = 2),
             arrangeGrob(PCA_12_Sector,PCA_23_Sector, ncol = 2),
             ncol=1)
dev.off()



#####Prueba de grupos con Multi-Response Permutation Procedure#####

#En esta prueba se realizaron 10000 permutaciones

library(vegan)

#Comparación entre las mareas
Mrpp_Marea<-mrpp(data_completo_CCCP, group= datos_CCCP$Marea, distance="bray", permutations = 10000)
#Comparación entre loas transectos
Mrpp_Transecto<-mrpp(data_completo_CCCP, group= datos_CCCP$Transecto, distance="bray", permutations = 10000)

Mrpp_No.Estacion<-mrpp(data_completo_CCCP, group= datos_CCCP$No.Estacion, distance="bray", permutations = 10000)

Mrpp_Sector<-mrpp(data_completo_CCCP, group= datos_CCCP$Sector, distance="bray", permutations = 10000)


Mrpp_Marea
Mrpp_Transecto
Mrpp_No.Estacion
Mrpp_Sector
summary(Mrpp_Marea)
summary(Mrpp_Transecto)
summary(Mrpp_No.Estacion)


