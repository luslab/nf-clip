#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for fastqc")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include peka from './peka.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.inputDir = "$baseDir/input"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files

    ch_testpeak = Channel.fromFilePairs( params.inputDir + "/*.{xl.bed.gz,xl_peaks.bed.gz}", flat: true)
    //ch_testpeak = Channel.fromPath(params.inputDir +"/*.{xl.bed.gz, xl_peaks.bed.gz}").view()
    // Run fastqc
    peka( ch_testpeak)

    // Collect file names and view output
    peka.out.collect() | view
    
}