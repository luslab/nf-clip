#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Get Crosslinks")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include getcrosslinks from './get-crosslinks.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

//params.bam = "$baseDir/input/*.dedup.bam"
//params.fai = "$baseDir/input/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/


testMetaData = [
  ['Sample 1', "prpf8_ctrl_rep1.dedup.bam"],
  ['Sample 2', "prpf8_ctrl_rep2.dedup.bam"],
  ['Sample 3', "prpf8_ctrl_rep4.dedup.bam"],
  ['Sample 4', "prpf8_eif4a3_rep1.dedup.bam"],
  ['Sample 5', "prpf8_eif4a3_rep2.dedup.bam"],
  ['Sample 6', "prpf8_eif4a3_rep4.dedup.bam"],
  ['Sample 7', "GRCh38.primary_assembly.genome_chr6_34000000_35000000.fai"],
  ['Sample 8', "GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"]
]

// Create channels of test data 

  Channel
  .from(testMetaData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .set {ch_test_meta}

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    //ch_testData = Channel.fromPath( params.bam )
    //ch_fai = Channel.fromPath (params.fai)

    // Run fastqc
    getcrosslinks( ch_test_meta )
    //getcrosslinks( ch_testData, ch_fai )

    // Collect file names and view output
    getcrosslinks.out.collect() | view
}