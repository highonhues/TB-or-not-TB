# TB-or-not-TB

This pipeline automates **whole-genome sequencing (WGS) analysis of *Mycobacterium tuberculosis***.  
It performs quality control, read trimming, variant calling, variant filtering, and antibiotic resistance profiling using a Nextflow and Conda.  



## Input format
- Paired-end FASTQ files (`*_1.fastq.gz`, `*_2.fastq.gz`)  
- Reference genome in **GenBank** format (`.gbk`)  



## Output format
- **QC Reports:** FastQC (`.html`, `.zip`) and MultiQC (`multiqc_report.html`)  
- **Trimmed reads:** `*_1.trimmed.fastq.gz`, `*_2.trimmed.fastq.gz`  
- **Snippy outputs:** `snps.vcf`, `snps.bam`, other variant calling files  
- **Filtered variants:** `tb_variant_snps.vcf`  
- **TB-Profiler results:**  
  - `<sample>.results.json`  
  - `<sample>.targets.vcf`  
  - `<sample>.report.html` (final drug resistance report)  
- **Reference FASTA:** converted from `.gbk` using `seqret`  



## Test case (provided in `params.yml`)  
The repo includes a small public dataset that will be downloaded automatically:  

- `004-2_1.fastq.gz`  
- `004-2_2.fastq.gz`  
- `ancestral_ref.gbk`  
- `chromosome.gff3`  

Running with this data is a quick way to validate the pipeline end-to-end.  

### Real use  
For real projects, supply your own:  
- Paired FASTQ files from *M. tuberculosis* isolates  
- A suitable reference genome in GenBank format  

Update `params.yml` accordingly.  

---

## How do I run it?  

1. **Install Nextflow**  
```bash
curl -s https://get.nextflow.io | bash
```

2. 

