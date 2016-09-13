#!/bin/bash

for chr in `seq 1 21`
do
echo "chr=$chr"
Rscript GWAS/convert_bed_to_gds.R chr${chr}.dose.info0.6.filtered
Rscript GWAS/gwas_test.covariates.R chr${chr}.dose.info0.6.filtered ${chr}
Rscript GWAS/output_gwas_results.covariates.R ${chr}
done

echo "Finished"
