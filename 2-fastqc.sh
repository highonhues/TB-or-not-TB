#!/bin/bash
#SBATCH --job-name=fastqc_multiqc
#SBATCH --mem=8G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/fastqc__%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/fastqc_%j.error


#=========================#
# USER CONFIGURATION      #
#=========================#
DATADIR="/scratch/home/agupta1/TB/tb-data/"
OUTDIR="/scratch/home/agupta1/TB/results/qcdata"
LOGSDIR="/scratch/home/agupta1/TB/logs"
#=========================#
# conda


# Proper conda init
# source /home/agupta1/miniconda3/etc/profile.d/conda.sh
conda init bash
source ~/.bashrc
echo "Conda activated. proceeding with fastqc..."

#steps for fastqc
conda activate fastqc

# Run FastQC on all FASTQ files in the data directory on non compressed also
echo "Starting FastQC analysis..."
fastqc  -t $SLURM_CPUS_PER_TASK -o "$OUTDIR" "$DATADIR"/*.fastq*



# Check if FastQC completed successfully
if [ $? -eq 0 ]; then
    echo "FastQC completed successfully"
else
    echo "FastQC failed"
    exit 1
fi
conda deactivate
for zip in "$OUTDIR"/*.zip
do 
unzip "$zip"
done 