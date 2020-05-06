#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting Cutadapt trimming test pipeline")

/* Define global params
--------------------------------------------------------------------------------------*/

params.cutadapt_output_prefix = 'trimmed_'

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include cutadapt from './cutadapt.nf' //addParams(cutadapt_process_name: 'cutadapt1')
//include cutadapt as cutadapt2 from './cutadapt.nf' addParams(cutadapt_process_name: 'cutadapt2')

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/


testMetaData = [
  ['Sample 1', "$baseDir/input/readfile1.fq.gz"],
  ['Sample 2', "$baseDir/input/readfile2.fq.gz"],
  ['Sample 3', "$baseDir/input/readfile3.fq.gz"],
  ['Sample 4', "$baseDir/input/readfile4.fq.gz"],
  ['Sample 5', "$baseDir/input/readfile5.fq.gz"],
  ['Sample 6', "$baseDir/input/readfile6.fq.gz"]
]


// Create channels of test data 

  Channel
  .from(testMetaData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .set {ch_test_meta}

  
/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run cutadapt
    cutadapt(ch_test_meta)

    // Collect file names and view output
    cutadapt.out | view

}