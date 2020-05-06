#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Get Crosslink Coverage")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include getcrosslinkcoverage from './get-crosslink-coverage.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

//params.bed = "$baseDir/input/*.xl.bed.gz"

//params.fai = "$baseDir/input/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

/*testMetaData = [
  ['Sample 1', "$baseDir/input/prpf8_ctrl_rep1.xl.bed.gz"],
  ['Sample 2', "$baseDir/input/prpf8_ctrl_rep2.xl.bed.gz"],
  ['Sample 3', "$baseDir/input/prpf8_ctrl_rep4.xl.bed.gz"],
  ['Sample 4', "$baseDir/input/prpf8_eif4a3_rep1.xl.bed.gz"],
  ['Sample 5', "$baseDir/input/prpf8_eif4a3_rep2.xl.bed.gz"],
  ['Sample 6', "$baseDir/input/prpf8_eif4a3_rep4.xl.bed.gz"]
]
*/


// Create channels of test data 

 /* Channel
  .from(testMetaData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .set {ch_test_meta} 
/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.bed )
    //ch_fai = Channel.fromPath (params.fai)

    // Run fastqc
    //getcrosslinkcoverage( ch_test_meta)
    getcrosslinkcoverage( ch_testData, ch_fai )

    // Collect file names and view output
    getcrosslinkcoverage.out | view

}

// TODO: implement fai in get-crosslink-coverage.nf