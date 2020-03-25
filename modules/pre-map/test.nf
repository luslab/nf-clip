#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Bowtie Pre-mapping to rRNA and tRNA")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include prefastqc from './pre-fastqc.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq.gz"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )

    // Run fastqc
    prefastqc( ch_testData )

    // Collect file names and view output
    prefastqc.out.collect() | view
}