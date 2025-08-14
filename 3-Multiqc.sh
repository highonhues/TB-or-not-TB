#!/bin/bash
#SBATCH --job-name=multiqc
#SBATCH --mem=8G
#SBATCH --cpus-per-task=6                  
#SBATCH --output=/scratch/home/agupta1/TB/logs/multiqc_%j.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/multiqc_%j.error


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
echo "Conda activated. proceeding with multiqc..."



#steps for multiqc
conda activate multiqc
echo "Starting MultiQC analysis..."
cd "$OUTDIR"
multiqc . 

# Check if MultiQC completed successfully
if [ $? -eq 0 ]; then
    echo "MultiQC completed successfully"
    echo "Results saved to: $OUTDIR"
else
    echo "MultiQC failed"
    exit 1
fi

echo "Quality control analysis complete!"