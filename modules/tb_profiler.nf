#!/usr/bin/env nextflow

/*
 * Run TB-Profiler and TBVCFReport on Snippy BAM outputs
 */
process TBProfiler {

    tag { sample_id }

    conda 'bioconda::tb-profiler=4.3.0 bioconda::tbvcfreport=0.1.3'

    publishDir "${params.profilerdir}", mode: 'copy'

    input:
    tuple val(sample_id), path(bam)

    output:
    tuple val(sample_id), path("${sample_id}.results.json"), path("${sample_id}.targets.vcf"), path("${sample_id}.report.html")
    script:
    """
    echo "Running TB-Profiler for sample: ${sample_id}"
    tb-profiler profile -a ${bam} -p ${sample_id}

    echo "Cleaning VCF..."
    gunzip -f ${sample_id}.targets.vcf.gz
    sed -i 's/GENE_//g' ${sample_id}.targets.vcf

    echo "Generating TBVCF report...."
    tbvcfreport generate -t ${sample_id}.results.json .
    """
}
