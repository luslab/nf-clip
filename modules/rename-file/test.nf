#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting Cutadapt trimming test pipeline")

/* Define global params
--------------------------------------------------------------------------------------*/

//params.cutadapt_output_prefix = 'trimmed_'

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include rename_file from './rename-file.nf'

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

  /*Channel
  .from(testPaths)
  .map { row -> file(row[1]) }
  .set {ch_test_inputs2}*/

//Create channel of test data IF IT IS PAIRED END DATA
/*Channel
  .fromFilePairs('./modules/cutadapt/input/*_{1,2}.fastq' )
  .set { ch_read_files }
*/

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run cutadapt
    cutadapt( ch_test_inputs )
    // Run cutadapt with paired-end inputs
    //cutadapt( ch_read_files )

    // Run cutadapt
    //cutadapt2( ch_test_inputs2 )

    

    // Collect file names and view output
    cutadapt.out | view 
    //cutadapt2.out | view

}