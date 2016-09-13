args <- commandArgs(trailingOnly = TRUE)
library(gdsfmt)
# 
tst.d<-"TESTS"
#col<-0
#tst.l<-c("cat","glmc")
tst.l<-c("glmc")
#Tst.l<-c("CAT","GLM")
#Tst.l<-c("GLM")
alt.g<-c("cd","d","r","a")
#Alt.g<-c("C","D","R","A")
phen.names<-c("G1","G2","G3","G4","G5","G6","G7", "G8")
#phen.names<-c("G1")
subb<-"all"
coffn<-"sex+age"

#
#pth.r<-paste0("/Volumes/rset1/HBV/genotypes/imputed_HRC/GWAS")        # root directory
pth.r <- paste0("/Volumes/rset1/HBV/genotypes/final/imputed/GWAS/chr", args[1])
pth.f<-"/Users/dzhernakova/Documents/tools/SOFTPARALLEL4/FUNCTIONS/DATA-MANEGEMENT.R"
pth.d0<-"DATA/dataset.gds"
pth.d<-paste0("DATA/dataset",subb,".gds")
#
source(pth.f)
setwd(pth.r)
#
pop<-"hbv"
#Pop<-"HBV"
tst.lst<-"NULL"
f.lst<-"NULL"
i<-0

dat<-openfn.gds(pth.d0)
snps = read.gdsn(index.gdsn(dat, "snp.rs.id"))
snp_pos = read.gdsn(index.gdsn(dat, "snp.position"))
snp_chr = read.gdsn(index.gdsn(dat, "snp.chromosome"))
closefn.gds(dat)
res_table <- as.data.frame(matrix(NA, nrow = length(snps)))
#row.names(res_table) <- snps
res_table$snp <- snps
res_table$position <- paste0(snp_chr, ":", snp_pos)
res_table$V1 <- NULL

for (i2 in 1:length(phen.names))
for (i1 in 1:length(tst.l))
for (i3 in 1:length(alt.g))
{ 
	i<-i+1
	tp<-tst.l[i1]
	pt<-phen.names[i2]
	gp<-alt.g[i3]
	col_name <- paste0(tp,"_",pop,"_",pt,"_all_", coffn, "_",gp)
	f.lst[i]<-paste0(col_name,".gds")
	
	dat<-openfn.gds(paste0(tst.d,"/",f.lst[i]))	
	res_table[,col_name] <- as.vector(read.gdsn(index.gdsn(dat,"tests.results")))$pv
	closefn.gds(dat)
}

write.table(res_table, file="OUTPUT/result_p-values.txt", quote = F, sep = "\t")
