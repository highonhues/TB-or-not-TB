#!/usr/bin/env nextflow

/*
 * Main pipeline for TB WGS analysis
 * Step 1: Download all required files from params.yml
 */

// Process modules
include { GET_WGS } from './modules/getwgs.nf'

// workflow definition
workflow{
    // get data files
    download_files=GET_WGS()
    download_files.view { file -> "Downloaded: ${file}" }
}