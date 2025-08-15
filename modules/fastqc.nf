#!/usr/bin/env nextflow

/*
 * run fastqc on input files
 */
process Fastqc {

    
    conda 'bioconda::fastqc=0.11.9'

    publishDir "${params.qcdir}", mode: 'copy'

    input:
        path fastq_file

    output:
        path "*.html"
        path "*.zip"

    script:
    """
    echo "Running FastQC on \$fastq_file...."
    fastqc -t ${task.cpus} -o . \$fastq_file
    """
}