#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for paraclu")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include paraclu from './paraclu.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

testCrosslinks = [
  ['Sample 1', "$baseDir/input/prpf8_ctrl_rep1.xl.bed.gz"],
  ['Sample 2', "$baseDir/input/prpf8_ctrl_rep2.xl.bed.gz"],
  ['Sample 3', "$baseDir/input/prpf8_ctrl_rep4.xl.bed.gz"],
  ['Sample 4', "$baseDir/input/prpf8_eif4a3_rep1.xl.bed.gz"],
  ['Sample 5', "$baseDir/input/prpf8_eif4a3_rep2.xl.bed.gz"],
  ['Sample 6', "$baseDir/input/prpf8_eif4a3_rep4.xl.bed.gz"]
]

  Channel
  .from(testCrosslinks)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .set {ch_test_crosslinks}

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run paraclu
    paraclu( ch_test_crosslinks )

    // Collect file names and view output
    paraclu.out.peaks | view
}