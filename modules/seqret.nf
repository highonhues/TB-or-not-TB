#!/usr/bin/env nextflow

/*
 * convert .gbk to .fasta for easier visualisation
 */
 process Seqret {

   // tells what file ur working on
     tag { ref_gbk.basename }  

    conda 'conda install bioconda::emboss=6.6.0'
    publishDir "results/reference", mode: 'copy'

    input:
    path ref_gbk

    output:
    path "seqretout.fasta"

    script:
    """
    echo "Converting GenBank file to FASTA: ${ref_gbk}"
    seqret -firstonly yes -sequence ${ref_gbk} -outseq seqretout.fasta
    """



 }