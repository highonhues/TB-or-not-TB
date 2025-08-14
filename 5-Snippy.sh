#!/bin/bash
#SBATCH --job-name=snippy
#SBATCH --mem=32G
#SBATCH --cpus-per-task=16                 
#SBATCH --output=/scratch/home/agupta1/TB/logs/snippy_%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/snippy_%j.error


#=========================#
# USER CONFIGURATION      #
#=========================#
DATADIR="/scratch/home/agupta1/TB/tb-data/cleandata"
OUTDIR="/scratch/home/agupta1/TB/results/snippy"
REF="/scratch/home/agupta1/TB/tb-data/Mycobacterium_tuberculosis_ancestral_reference.gbk"
#=========================#



# Proper conda init
source /home/agupta1/miniconda3/etc/profile.d/conda.sh

#source ~/.bashrc
echo "Conda activated. proceeding with snippy..."

conda activate snippy



# Running snippy with specific outdir for each run

for R1 in "$DATADIR"/*_1.trimmed.fastq*; do
    R2="${R1/_1.trimmed.fastq/_2.trimmed.fastq}"
    sample=$(basename "$R1" .fastq.gz)  # Remove .fastq.gz
    sample=${sample%_1.trimmed}         # Remove _1.trimmed suffix
    
    echo "Processing $sample..."
    SAMPLE_OUTDIR="$OUTDIR/$sample"

    snippy --ref "$REF" --outdir "$SAMPLE_OUTDIR" --force --cpus "$SLURM_CPUS_PER_TASK" --minfrac 0.1 --pe1 "$R1" --pe2 "$R2" 
done

conda deactivate
#could add a running thing if it fails by checking file existence
echo "finiished with snippy"