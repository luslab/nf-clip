#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include bedtools_intersect from './bedtools.nf'
 
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
    // Run bedtools_intersect
    bedtools_intersect( ch_test_crosslinks )

    // Collect file names and view output
    bedtools.out | view
}

