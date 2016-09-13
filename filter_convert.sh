#!/bin/bash

chrs=( "$@" )
for chr in ${chrs[@]}
do

echo "Starting to process chr ${chr}"
unzip -o -P n4VXCmiWbAhS7 chr_${chr}.zip

echo "Filtering by info > 0.6, adding rs ids"
gzcat chr${chr}.dose.vcf.gz | sed 's:PASS;GENOTYPED:PASS:g' | bcftools filter -i 'INFO/R2>0.6' - -Oz > chr${chr}.dose.info0.6.tmp.vcf.gz
tabix -p vcf chr${chr}.dose.info0.6.tmp.vcf.gz
 
bcftools annotate \
-a ~/Documents/resources/b37/variation/HRC.r1.GRCh37.autosomes.mac5.sites.vcf.gz \
-c ID chr${chr}.dose.info0.6.tmp.vcf.gz \
> chr${chr}.dose.info0.6.ids.vcf

rm chr${chr}.dose.info0.6.tmp.vcf.gz*

echo "converting to bed"
~/Documents/tools/plink-1.9_beta/plink \
--vcf chr${chr}.dose.info0.6.ids.vcf \
--maf 0.05 \
--hwe 0.0001 \
--geno 0.05 \
--make-bed \
--out chr${chr}.dose.info0.6.filtered

rm chr${chr}.dose.info0.6.vcf.*
rm chr${chr}.dose.info0.6.ids.vcf
done
echo "Finished"
