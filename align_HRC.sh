for chr in `seq 1 22`
do
echo $chr
~/Documents/tools/plink-1.9_beta/plink \
--bfile ../HBV.final2 \
--chr ${chr} \
--make-bed \
--out HBV.final2.chr${chr}

java -Xmx50g \
-jar ~/Documents/tools/GenotypeHarmonizer-1.4.15/GenotypeHarmonizer.jar \
-i HBV.final2.chr${chr} \
-I PLINK_BED \
-r ~/Documents/resources/b37/variation/HRC.r1.GRCh37.autosomes.mac5.sites.vcf.gz \
-R VCF \
-o HBV.final2.chr${chr}.alignedHRC


~/Documents/tools/plink-1.9_beta/plink \
--recode vcf-iid bgz \
--bfile  HBV.final2.chr${chr}.alignedHRC \
--out HBV.final2.chr${chr}.alignedHRC
done

echo "Finished!"
