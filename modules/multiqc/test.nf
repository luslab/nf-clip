#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for multiqc")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include multiqc from './multiqc.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

//params.log_dir = "$baseDir/results/*.log"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from log files
    ch_testData = Channel.fromPath( "test" )

    // Run multiqc
    multiqc ( ch_testData )

    // Collect file names and view output
    multiqc.out.collect() | view
}