#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for fastqc")

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
    log.info ("starting workflow")

    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )

    prefastqc( ch_testData )
}

//workflow.onComplete {// 
//	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
//}