#!/usr/bin/env nextflow

/*
 * Main pipeline for TB WGS analysis
 * Step 1: Download all required files from params.yml
 */

// Process modules
include { GET_WGS } from './modules/getwgs.nf'
include { Fastqc } from './modules/fastqc.nf'
include { Multiqc } from './modules/multiqc.nf'
include { Fastp } from './modules/fastp.nf'

// workflow definition
workflow{
    // get data files
    downloaded_files = GET_WGS()
    //download_files.view { file -> "Downloaded: ${file}" }

    //run Fastqc
    fastq_files = downloaded_files.filter { it.name.endsWith(".fastq.gz") }
    fastqc_results = Fastqc(fastq_files)

    // multiqc
    Multiqc(fastqc_results.collect())

    //fastp trimming
    paired_reads = raw_fastq
        .groupTuple { file -> file.name.replaceAll(/_1\.fastq\.gz|_2\.fastq\.gz/, '') }
        .map { id, reads -> tuple(reads.find { it.name.contains("_1") }, reads.find { it.name.contains("_2") }) }

    Fastp(paired_reads)


}