#!/usr/bin/env nextflow
/*
========================================================================================
                         luslab/group-nextflow-clip
========================================================================================
Luscombe lab CLIP analysis pipeline.
 #### Homepage / Documentation
 https://github.com/luslab/group-nextflow-clip
----------------------------------------------------------------------------------------
*/

// Define DSL2
nextflow.preview.dsl=2

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include luslabHeader from './modules/overhead/overhead'
include prefastqc from './modules/pre-fastqc/pre-fastqc.nf'
include prefastqc as postfastqc from './modules/pre-fastqc/pre-fastqc.nf' 
include cutadapt from './modules/trim-reads/trim-reads.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/test/reads/*.fq.gz"

/*------------------------------------------------------------------------------------*/

// Run workflow
log.info luslabHeader()
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )

    // Run fastqc
    prefastqc( ch_testData )

    //Run read trimming
    cutadapt( ch_testData )
    postfastqc( cutadapt.out )

    // Collect file names and view output
    //prefastqc.out.collect() | view
    postfastqc.out.collect() | view
    
}
/*------------------------------------------------------------------------------------*/
