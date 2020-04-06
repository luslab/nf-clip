#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting Cutadapt trimming test pipeline")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include cutadapt from './trim-reads.nf' \
  params\
  (outdir: './results', \
   cutadapt_processname: 'cutadapt', \
   task_cpus: 8, \
   cutadapt_min_quality: 10, \
   cutadapt_min_length: 16, \
   adapter_sequence: 'AGATCGGAAGAGC')

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

testPaths = [
  ['Sample 1', "$baseDir/input/readfile1.fq.gz"],
  ['Sample 2', "$baseDir/input/readfile2.fq.gz"],
  ['Sample 3', "$baseDir/input/readfile3.fq.gz"],
  ['Sample 4', "$baseDir/input/readfile4.fq.gz"],
  ['Sample 5', "$baseDir/input/readfile5.fq.gz"],
  ['Sample 6', "$baseDir/input/readfile6.fq.gz"]
]

// Create channel of test data (excluding the sample ID)

 Channel
  .from(testPaths)
  .map { row -> file(row[1]) }
  .set {ch_test_inputs}

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run cutadapt
    cutadapt( ch_test_inputs )

    // Collect file names and view output
    cutadapt.out | view 
}