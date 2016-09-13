# exclude samples wirth missing rate > 0.05, heterozygosity outliers
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8 --missing --out just_hbv8
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8 --het --out just_hbv8
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8 --remove to_exclude_missing_rate.txt --make-bed --out just_hbv8.imiss_removed

#pruning
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed --indep-pairwise 50 5 0.2 --out just_hbv8.imiss_removed
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed --extract just_hbv8.imiss_removed.prune.in --make-bed --out just_hbv8.imiss_removed.pruned

#IBD
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.pruned --genome --out just_hbv8.imiss_removed.pruned
ln -s just_hbv8.imiss just_hbv8.imiss_removed.pruned.imiss
perl run-IBD-QC.pl just_hbv8.imiss_removed.pruned
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed --remove fail-IBD-QC.txt --make-bed --out just_hbv8.imiss_removed.ibd_removed

#PCA
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.ibd_removed --indep-pairwise 50 5 0.2 --out just_hbv8.imiss_removed.ibd_removed
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.ibd_removed --extract just_hbv8.imiss_removed.ibd_removed.prune.in --make-bed --out just_hbv8.imiss_removed.ibd_removed.pruned
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.ibd_removed.pruned --pca --out just_hbv8.imiss_removed.ibd_removed.pruned.pca

~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.ibd_removed --remove to_exclude_pca.txt --make-bed --out just_hbv8.imiss_removed.ibd_removed.pca_removed

# CR > 0.95, MAF > 0.01, HWE P > 1e-5
~/Documents/tools/plink-1.9_beta/plink --bfile just_hbv8.imiss_removed.ibd_removed.pca_removed --maf 0.01 --geno 0.05 --hwe 0.00001 --make-bed --out just_hbv8.imiss_removed.ibd_removed.pca_removed.geno_filtered

for f in just_hbv8.imiss_removed.ibd_removed.pca_removed.geno_filtered*; do mv $f HBV.final2.${f##*.}; done
mv *.log logs/
mv HBV.final2* ../final/

