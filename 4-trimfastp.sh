#!/bin/bash
#SBATCH --job-name=fastp
#SBATCH --mem=16G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/fastp_%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/fastp_%j.error


#=========================#
# USER CONFIGURATION      #
#=========================#
DATADIR="/scratch/home/agupta1/TB/tb-data/"
OUTDIR="/scratch/home/agupta1/TB/tb-data/cleandata"
#=========================#



# Proper conda init
# source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda init bash
source ~/.bashrc
echo "Conda activated. proceeding with fastp..."


conda activate fastp

# Process all paired files
for R1 in "$DATADIR"/*_1.fastq*; do
    R2="${R1/_1.fastq/_2.fastq}"
    sample=$(basename "$R1" | sed 's/_1\.fastq.*$//')
    
    echo "Processing $sample..."
    
    fastp -i "$R1" -o "$OUTDIR/${sample}_1.trimmed.fastq.gz" \
        -I "$R2"   -O "$OUTDIR/${sample}_2.trimmed.fastq.gz" \
        -w $SLURM_CPUS_PER_TASK \
        --json "$OUTDIR/${sample}.json" \
        --html "$OUTDIR/${sample}.html"
done

echo "finiished with fastp"