#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for fastqc")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include getcrosslinks from './get-crosslinks.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.bam = "$baseDir/input/*.dedup.bam"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.bam )

    // Run fastqc
    getcrosslinks( ch_testData )

    // Collect file names and view output
    getcrosslinks.out.collect() | view
}