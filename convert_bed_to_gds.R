args <- commandArgs(trailingOnly = TRUE)

library(gdsfmt)
library(SNPRelate)
#
inst.plink<-function(path.fn)
   {
     bd<-".bed"
     fm<-".fam"
     bm<-".bim"
     gd<-"_tmp.gds"
     snpgdsBED2GDS(paste(path.fn,bd,sep=""),paste(path.fn,fm,sep=""),paste(path.fn,bm,sep=""),paste(path.fn,gd,sep=""))
   } 
# Genotype
path.fn <- args[1]
paste0("Input file base:", path.fn)
inst.plink(path.fn)
#
dd<-openfn.gds(paste0(path.fn,"_tmp.gds"))
id<-read.gdsn(index.gdsn(dd,"sample.id"))
sex<-read.gdsn(index.gdsn(dd,"sample.annot"))$sex
closefn.gds(dd)
# Phenotype
path.pt<-"/Volumes/rset1/HBV/genotypes/final/HBV.final2.phenotypes.age.csv"
pht<-read.table(path.pt,sep="\t",col.names=c("ID","Gr","Expl","Age"))
rk<-rank(id)
pht<-pht[rk,]
# Groups
G<-pht$Gr
# I A vs. BCDE
G1<-as.numeric(G=="A")
G1[G=="F"]<-NA
# II F vs. BCDE
G2<-as.numeric(G=="F")
G2[G=="A"]<-NA
# III AF vs. BCDE
G3<-as.numeric(G=="A"| G=="F")
# IV B vs. CDE
G4<-as.numeric(G=="B")
G4[G=="A"|G=="F"]<-NA
# V  C vs. DE
G5<-as.numeric(G=="C")
G5[G=="A"|G=="F"|G=="B"]<-NA
# VI  BC vs. D
G6<-as.numeric(G=="B"|G=="C")
G6[G=="A"|G=="F"|G=="E"]<-NA
# VII  BC vs. DE
G7<-as.numeric(G=="B"|G=="C")
G7[G=="A"|G=="F"]<-NA
# VIII  E vs. BC
G8<-as.numeric(G=="E")
G8[G=="A"|G=="D"|G=="F"]<-NA
# covariates
path.pc<-"/Volumes/rset1/HBV/genotypes/final/imputed/all_chr/all_chr.dose.info0.6.filtered.pruned.pca.eigenvec"
cvt<-read.table(path.pc)
pc1<-cvt[,3]
pc2<-cvt[,4]
#
age=pht$Age
pht<-data.frame(sex=sex,phenotype=G,G1=G1,G2=G2,G3=G3,G4=G4,G5=G5,G6=G6,G7=G7, G8=G8, PC1=pc1,PC2=pc2,age=age)
# Finalization
path.ff <- paste0(path.fn, ".gds")
snpgdsCreateGenoSet(paste0(path.fn,"_tmp.gds"),path.ff)
# 
dd<-openfn.gds(path.ff,readonly=FALSE)
add.gdsn(dd,"sample.annot",val=pht)
closefn.gds(dd)
# 
unlink(paste0(path.fn,"_tmp.gds"))
