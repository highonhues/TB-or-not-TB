/*
 * run fastqc on input files
 */
process Fastqc {

    
    conda 'bioconda::fastqc=0.11.9'

    publishDir params.outdir, mode: 'symlink'

    input:
        path input_bam

    output:
        path "${input_bam}.bai"

    script:
    """
    samtools index '$input_bam'
    """
}