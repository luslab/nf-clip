#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for BAM deduplication")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include bamdedup from './deduplicate-bam.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.inputDir = "$baseDir/input"
/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all bam files
    ch_bamBaiFiles = Channel.fromFilePairs( params.inputDir + '/*.{bai,bam}', flat: true )

    // Run dedup
    bamdedup( ch_bamBaiFiles )

    // Collect file names and view output
    bamdedup.out.collect() | view
}