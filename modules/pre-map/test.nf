#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Bowtie Pre-mapping to rRNA and tRNA")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include pre-map from './modules/pre-map/pre-map.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq.gz"
params.bowtie_index = "$baseDir/input/small_rna_bowtie/small_rna_bowtie.*"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    index = Channel.fromPath( params.bowtie_index )

    // Run pre-map
    pre-map( ch_testData, index )

    // Collect file names and view output
    pre-map.out.collect() | view
}