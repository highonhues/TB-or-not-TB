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
include { Snippy } from './modules/snippy.nf'
include { TBFilter } from './modules/tb_filter.nf'
include { TBProfiler }  from './modules/tb_profiler.nf'
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
    paired_reads = fastq_files
        .groupTuple { file -> file.name.replaceAll(/_1\.fastq\.gz|_2\.fastq\.gz/, '') }
        .map { id, reads -> tuple(reads.find { it.name.contains("_1") }, reads.find { it.name.contains("_2") }) }


    trimmed_reads = Fastp(paired_reads)

    // Run FastQC on trimmed reads
    fastqc_trimmed = Fastqc(trimmed_reads.flatten())

    // Final MultiQC combining raw + trimmed QC results
    params.qcdir = "results/qcdata/trimmed"
    Multiqc(fastqc_trimmed.collect())
    final_qc_inputs = fastqc_results.concat(fastqc_trimmed).collect()
    params.qcdir = "results/qcdata/final"
    Multiqc(final_qc_inputs)

    //snippy
    snippy_results = Snippy(trimmed_reads)

    // tb variant filter-takes vcf from snippy
    tbfilter_results = TBFilter(snippy_results.map { id, files -> tuple(id, files.find { it.name == "snps.vcf" })})

    // Step 8: TB Profiler (takes BAM + VCF.GZ from Snippy)
    tbprofiler_results = TBProfiler(snippy_results.map { id, files ->
        tuple(id,
              files.find { it.name == "snps.bam" },
             files.find { it.name == "targets.vcf.gz" }
        )
    })



}