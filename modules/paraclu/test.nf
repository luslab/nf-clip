#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for paraclu")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include paraclu from './paraclu.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.crosslinks = "$baseDir/input/*.bed.gz"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.crosslinks )

    // Run paraclu
    paraclu( ch_testData )

    // Collect file names and view output
    paraclu.out.collect() | view
}