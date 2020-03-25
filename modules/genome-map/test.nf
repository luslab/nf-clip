#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for genome mapping")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include genomemap from './genome-map.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq"
params.genome_index = "$baseDir/input/reduced_star_index"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    ch_testIndex = Channel.fromPath( params.genome_index )
    

    // Run fastqc
    genomemap( ch_testData, ch_testIndex )

    // Collect file names and view output
    genomemap.out.collect() | view
}