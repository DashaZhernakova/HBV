args <- commandArgs(trailingOnly = TRUE)
#num<-args[1]
# phenotype
phen.names<-c("G1","G2","G3","G4","G5","G6","G7", "G8")
#phen.name<-"G1"
# arguments
pth.b<-"/Volumes/rset1/HBV/genotypes/final/imputed/"              # parent directory for input data 
#inp.f<-"chr1.dose.info0.6-temporary_res"                                      # input files name
inp.f<- args[1]
pth.r<-paste0("/Volumes/rset1/HBV/genotypes/final/imputed/GWAS/chr", args[2])        # root directory
pth.t<-"/Users/dzhernakova/Documents/tools/SOFTPARALLEL4/PROGS/MOD/"            # directory for soft
pth.f<-"/Users/dzhernakova/Documents/tools/SOFTPARALLEL4/FUNCTIONS/DATA-MANEGEMENT.R"
pth.fc<-"/Users/dzhernakova/Documents/tools/SOFTPARALLEL4/FUNCTIONS/CATEGORICAL.R"
file.type<-c("gdsc",NA)  	 # type of the input data files (vector of "plink","csv","gds", length 2 for genotype data and clynical data)
alt.g<-c("cd","d","r","a")   # alternatives (vector of "cd","d","r","a")
pop<-"hbv"                   # population name
d.tpe<-"cont"                 # a string "cat", "rsurv", "survint", "long" ...
tst.l<-c("glmc")#,"cat")      # list of tests (vector of strings "cat","glmc","nsrv","cox","psrv")  !will be extended!
# population filter
sub<-"all"; subb<-"all"        # groupping "all" or vector group=c("varname","action",value,"operation","varname","action",value,...)
#sub<-list("Smoke","==",0); subb<-"smk0"
# covariates
coff<-c("sex", "+", "age"); coffn<-c("sex+age")
#formula<-"phenotype<-gen"
kl<-12
k<-12
#
dir.create(pth.r,showWarnings=FALSE)
source(pth.f)
source(pth.fc)
formatg<-file.type[1]
# creating workspace 
c.d(pth.r)
# setwd(pth.r)
# stage 1 (input data)
if (formatg=="gdsc") file.copy(paste0(pth.b,"/",inp.f,".gds"),"DATA/dataset.gds") else inst.gds(paste0(pth.b,"/",inp.f,"_g"),paste0(pth.b,"/",inp.f,"_p"),file.type[1],file.type[2])
#
pth.d0<-"DATA/dataset.gds"
pth.d<-paste0("DATA/dataset",subb,".gds")
## stage 2 (subset)
#grp.fn(sub,pth.d0,pth.d)
## stage 3 (annotation)
# snp.ftr(pth.d)
## phenotype selection
#data.f1<-openfn.gds(pth.d,readonly=FALSE)
#pt<-read.gdsn(index.gdsn(data.f1,"sample.annot"))$phenotype
#add.gdsn(data.f1,"phenotype", val=pt,compress="ZIP",closezip=TRUE)
#closefn.gds(data.f1)
## phenotype change
for (phen.name in phen.names)
{	
	# stage 2 (subset)
	dat.f<-openfn.gds(pth.d0)
	id<-read.gdsn(index.gdsn(dat.f,"sample.id"))
	snp<-read.gdsn(index.gdsn(dat.f, "snp.id"))
	pos<-read.gdsn(index.gdsn(dat.f, "snp.position"))
	chr<-read.gdsn(index.gdsn(dat.f, "snp.chromosome"))
	all<-read.gdsn(index.gdsn(dat.f, "snp.allele"))
	gen<-read.gdsn(index.gdsn(dat.f, "genotype"))
	phen<-read.gdsn(index.gdsn(dat.f,"sample.annot"))
	closefn.gds(dat.f)
	#
	pt<-phen[[phen.name]]
	subs<-!is.na(pt)
	id<-id[subs] # samples with this phenotype not NA
	phen<-phen[subs,]
	gen<-gen[subs,]
 	dat.f<-createfn.gds(pth.d)
	add.gdsn(dat.f,"sample.id", val=id,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"snp.id", val=snp,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"snp.position", val=pos,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"snp.chromosome", val=chr,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"snp.allele", val=all,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"genotype", val=gen,compress="ZIP",closezip=TRUE,storage="bit2")
	add.gdsn(dat.f,"sample.annot", val=phen,compress="ZIP",closezip=TRUE)
	add.gdsn(dat.f,"phenotype", val=phen[[phen.name]],compress="ZIP",closezip=TRUE)
 	closefn.gds(dat.f)
	# stage 4 (partition for clusters)
	source(paste0(pth.t,"partition.r"))
	# stage 3 (annotation)
	tests_par_snpftr(pth.r,pth.f,kl)
	# stage 5 (TESTS)
	for (alt in alt.g) source(paste0(pth.t,"tests_par.r"))
	# stage 5a cleaning
	for (i in 1:k) unlink(paste0("DATA/tmpdataset_",i,".gds"))
}
# stage 6 (output gds)
#tbl.gds()
# stage 7 (output csv)
#tbl.csv()

 





