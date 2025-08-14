#!/bin/bash
#SBATCH --job-name=tb_profiler_report
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --output=/scratch/home/agupta1/TB/logs/tb_profiler_%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/tb_profiler_%j.error


#=========================#
# USER CONFIGURATION      #
#=========================#
SNIPPYDIR="/scratch/home/agupta1/TB/results/snippy"
OUTDIR="/scratch/home/agupta1/TB/results/tbprofiler"
#=========================#

# Ensure output directory exists
mkdir -p "$OUTDIR"

# Proper conda init
source /home/agupta1/miniconda3/etc/profile.d/conda.sh

#############################
#Step 1: TB-Profiler
conda activate tbprofiler
echo "Conda activated: tbprofiler"

for BAM in "$SNIPPYDIR"/*/snps.bam; do
    SAMPLE=$(basename "$(dirname "$BAM")")
    SAMPLE_OUT="$OUTDIR/$SAMPLE"

    echo "Running TB-Profiler for sample: $SAMPLE"
    tb-profiler profile -a "$BAM" -p "$SAMPLE_OUT"
done
conda deactivate
##################################

#Step 2: Clean vcf and report

conda activate tbvcfreport
echo "Conda activated: tbvcfreport"

for JSON in "$OUTDIR"/*.results.json; do
    SAMPLE=$(basename "$JSON" .results.json)
    VCF_GZ="$OUTDIR/${SAMPLE}.targets.vcf.gz"
    VCF="$OUTDIR/${SAMPLE}.targets.vcf"

    echo "Processing report for sample: $SAMPLE"

    # Remove "GENE_" from VCF
    gunzip -f "$VCF_GZ"
    sed -i 's/GENE_//g' "$VCF"

    # Generate TBVCF report
    tbvcfreport generate -t "$JSON" "$VCF"
done
conda deactivate

echo "Finished TB-Profiler + TBVCFReport for all samples."
