#!/bin/bash
#SBATCH --job-name=tb_filter
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --output=/scratch/home/agupta1/TB/logs/tb_filter_%j.out
#SBATCH --error=/scratch/home/agupta1/TB/logs/tb_filter_%j.err
 # Proper conda init
source /home/agupta1/miniconda3/etc/profile.d/conda.sh

#source ~/.bashrc
echo "Conda activated. proceeding with tbvar..."

conda activate tbvar

# Loop over all snps.vcf files from Snippy results
for VCF_IN in /scratch/home/agupta1/TB/results/snippy/*/snps.vcf; do
    OUTDIR=$(dirname "$VCF_IN")
    VCF_OUT="$OUTDIR/tb_variant_snps.vcf"

    echo "Processing: $VCF_IN"
    tb_variant_filter  --region_filter pe_ppe --region_filter uvp --indel_window_size 5 --min_percentage_alt 90.0 --min_depth 30 "$VCF_IN" "$VCF_OUT"
done

conda deactivate
echo "Finished TB Variant Filter"
