#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for BAM deduplication")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include dedup from './deduplicate-bam.nf'

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

testMetaDataBam = [
  ['Sample 1', "$baseDir/input/prpf8_ctrl_rep1.Aligned.sortedByCoord.out.bam"],
  ['Sample 2', "$baseDir/input/prpf8_ctrl_rep2.Aligned.sortedByCoord.out.bam"],
  ['Sample 3', "$baseDir/input/prpf8_ctrl_rep4.Aligned.sortedByCoord.out.bam"],
  ['Sample 4', "$baseDir/input/prpf8_eif4a3_rep1.Aligned.sortedByCoord.out.bam"],
  ['Sample 5', "$baseDir/input/prpf8_eif4a3_rep2.Aligned.sortedByCoord.out.bam"],
  ['Sample 6', "$baseDir/input/prpf8_eif4a3_rep4.Aligned.sortedByCoord.out.bam"]
]

testMetaDataBai = [
  ['Sample 1', "$baseDir/input/prpf8_ctrl_rep1.Aligned.sortedByCoord.out.bai"],
  ['Sample 2', "$baseDir/input/prpf8_ctrl_rep2.Aligned.sortedByCoord.out.bai"],
  ['Sample 3', "$baseDir/input/prpf8_ctrl_rep4.Aligned.sortedByCoord.out.bai"],
  ['Sample 4', "$baseDir/input/prpf8_eif4a3_rep1.Aligned.sortedByCoord.out.bai"],
  ['Sample 5', "$baseDir/input/prpf8_eif4a3_rep2.Aligned.sortedByCoord.out.bai"],
  ['Sample 6', "$baseDir/input/prpf8_eif4a3_rep4.Aligned.sortedByCoord.out.bai"]
]

// Create channels of test data 

//Bam input channel
Channel
  .from(testMetaDataBam)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ]}
  .set {ch_test_meta_bam}

//BamBai input channel
Channel
  .from(testMetaDataBai)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .join(ch_test_meta_bam)
  .set {ch_test_meta_bambai} 

// Run workflow
workflow {

    // Run dedup
    dedup( ch_test_meta_bambai )

    // Collect file names and view output
    dedup.out.dedupBam | view
}