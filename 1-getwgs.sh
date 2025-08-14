#!/bin/bash
#SBATCH --job-name=zenodo_grab
#SBATCH -p nodes
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1 
#SBATCH --output=/scratch/home/agupta1/TB/logs/zenodo_grab.output
#SBATCH --error=/scratch/home/agupta1/TB/logs/zenodo_grab_%j.error

DATADIR="/scratch/home/agupta1/TB/tb-data"


#url list
URLS=("https://zenodo.org/record/3960260/files/004-2_1.fastq.gz"
"https://zenodo.org/record/3960260/files/004-2_2.fastq.gz"
"https://zenodo.org/record/3960260/files/Mycobacterium_tuberculosis_ancestral_reference.gbk"
"https://zenodo.org/record/3960260/files/Mycobacterium_tuberculosis_h37rv.ASM19595v2.45.chromosome.Chromosome.gff3")

# -P is for prefixdir/ of where to save, -nc skips files if they are alread there
for url in "${URLS[@]}"; do
   wget -nc -P "$DATADIR" "$url"
done

#gunzip fastq
gunzip "DATADIR"/*.fastq.gz