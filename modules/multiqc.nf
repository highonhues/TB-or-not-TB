#!/usr/bin/env nextflow

/*
 * run MultiQC on all FastQC outputs
 */
process Multiqc {


    conda 'bioconda::multiqc=1.6'


    publishDir "${params.qcdir}", mode: 'copy'

    input:
        path fastqc_results

    output:
        path "multiqc_report.html"
        path "multiqc_data"

    script:
    """
    echo "Running MultiQC on FastQC outputs..."
    multiqc .
    """
}
