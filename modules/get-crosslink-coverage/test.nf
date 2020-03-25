#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for fastqc")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include getcrosslinkcoverage from './get-crosslink-coverage.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.bed = "$baseDir/input/*.xl.bed.gz"
params.fai = "$baseDir/input/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.bed )
    ch_fai = Channel.fromPath (params.fai)

    // Run fastqc
    getcrosslinkcoverage( ch_testData, ch_fai )

    // Collect file names and view output
    getcrosslinks.out.collect() | view

}