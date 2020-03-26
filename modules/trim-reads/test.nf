#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting Cutadapt trimming pipeline")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include cutadapt from './trim-reads.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

testPaths = [
  ['Sample 1', ["$baseDir/input/readfile1.fq.gz"], ["$baseDir/output/output1.fq.gz"]],
  ['Sample 2', ["$baseDir/input/readfile2.fq.gz"], ["$baseDir/output/output2.fq.gz"]],
  ['Sample 3', ["$baseDir/input/readfile3.fq.gz"], ["$baseDir/output/output3.fq.gz"]],
  ['Sample 4', ["$baseDir/input/readfile4.fq.gz"], ["$baseDir/output/output4.fq.gz"]],
  ['Sample 5', ["$baseDir/input/readfile5.fq.gz"], ["$baseDir/output/output5.fq.gz"]],
  ['Sample 6', ["$baseDir/input/readfile6.fq.gz"], ["$baseDir/output/output6.fq.gz"]]
]

Channel
  .from(testPaths)
  .map { row -> [ row[0], [ file(row[1][0]) ] ] }
  .set { ch_test_inputs }

  Channel
  .from(testPaths)
  .map { row -> [ row[0], [ file(row[2][0]) ] ] }
  .set { ch_test_outputs }


//params.reads = "$baseDir/input/*.fq.gz"

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {


    // Create test data channel from all read files
    //ch_test_data = Channel.fromPath( params.reads )

    // Run fastqc
    cutadapt( ch_test_inputs )

    //Join outputs to correct output test file
    cutadapt.out.join(ch_test_outputs) | view

    // Collect file names and view output
    //cutadapt.out | view
}