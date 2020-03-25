#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Bowtie Pre-mapping to rRNA and tRNA")

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq.gz"
params.bowtie_index = "$baseDir/input/small_rna_bowtie"


/* Module inclusions 
--------------------------------------------------------------------------------------*/

include bowtie_rrna from './pre-map.nf'

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    ch_testIndex = Channel.fromPath( params.bowtie_index )

        // Run pre-map
    bowtie_rrna( ch_testData, ch_testIndex )

    // Collect file names and view output
    // bowtie_rrna.out.collect()
}

