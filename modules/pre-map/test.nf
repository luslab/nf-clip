#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Bowtie Pre-mapping to rRNA and tRNA")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include premap from './pre-map.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq.gz"
params.bowtie_index = "$baseDir/input/small_rna_bowtie/small_rna_bowtie"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    
    // Run pre-map
    premap( ch_testData , params.bowtie_index )

    // Collect file names and view output
    premap.out.collect() | view
}

