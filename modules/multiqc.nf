#!/usr/bin/env nextflow

/*
 * run multiqc on output files
 */
process Multiqc {

    conda 'bioconda::multiqc=1.21'
    

    publishDir "${params.qcdir}", mode: 'copy'

    input:
        path qc_results_dir

    output:
        path "multiqc_report.html"
        path "multiqc_data"

    script:
    """
    echo "Running MultiQC on \$qc_results_dir..."
    multiqc \$qc_results_dir
    """
}