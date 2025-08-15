#!/usr/bin/env nextflow

/*
 * run fastp on paired FASTQ files
 */
process Fastp {


    conda 'bioconda::fastp=1.0.1'

    publishDir "${params.cleandir}", mode: 'copy'

    input:
        tuple path(read1), path(read2)

    output:
        tuple path("${read1.simpleName.replaceAll(/_1$/, '')}_1.trimmed.fastq.gz"),
              path("${read2.simpleName.replaceAll(/_2$/, '')}_2.trimmed.fastq.gz")
        path "*.json"
        path "*.html"

    script:
    sample_id = read1.simpleName.replaceAll(/_1$/, '') // basename
    """
    echo "processing sample ${sample_id}...."

    fastp \
        -i ${read1} \
        -I ${read2} \
        -o ${sample_id}_1.trimmed.fastq.gz \
        -O ${sample_id}_2.trimmed.fastq.gz \
        -w ${task.cpus} \
        --json ${sample_id}.json \
        --html ${sample_id}.html
    """
}
