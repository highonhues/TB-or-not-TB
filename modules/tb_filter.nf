#!/usr/bin/env nextflow

/*
 * Run TB Variant Filter on Snippy VCF outputs
 */
process TBFilter {

    tag { sample_id }

    conda 'bioconda::tb-variant-filter=0.4.0' 

    publishDir "${params.snippydir}", mode: 'symlink'

    input:
    tuple val(sample_id), path(vcf_in)

    output:
    tuple val(sample_id), path("tb_variant_snps.vcf")

    script:
    """
    echo "Processing: ${vcf_in}"
    tb_variant_filter \
        --region_filter pe_ppe \
        --region_filter uvp \
        --indel_window_size 5 \
        --min_percentage_alt 90.0 \
        --min_depth 30 \
        ${vcf_in} tb_variant_snps.vcf
    """
}
