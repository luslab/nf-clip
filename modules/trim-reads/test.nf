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
  ['Sample 1', ["$baseDir/input/readfile1.fq.gz"]],
  ['Sample 2', ["$baseDir/input/readfile2.fq.gz"]],
  ['Sample 3', ["$baseDir/input/readfile3.fq.gz"]],
  ['Sample 4', ["$baseDir/input/readfile4.fq.gz"]],
  ['Sample 5', ["$baseDir/input/readfile5.fq.gz"]],
  ['Sample 6', ["$baseDir/input/readfile6.fq.gz"]]
]

// Create channel of test data
Channel
  .from(testPaths)
  .map { row -> [ row[0], [ file(row[1][0]) ] ] }
  .set { ch_test_inputs }

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run fastqc
    cutadapt( ch_test_inputs )

    // Collect file names and view output
    cutadapt.out | view
}