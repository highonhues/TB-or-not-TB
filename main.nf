#!/usr/bin/env nextflow

/*
 * Main pipeline for TB WGS analysis
 * Step 1: Download all required files from params.yml
 */

// Process modules
include { GET_WGS } from './modules/getwgs.nf'
include { Fastqc } from './modules/fastqc.nf'


// workflow definition
workflow{
    // get data files
    downloaded_files=GET_WGS()
    //download_files.view { file -> "Downloaded: ${file}" }

    //run Fastqc
    fastq_files = downloaded_files.filter { it.name.endsWith(".fastq.gz") }
    Fastqc(fastq_files)
    

}