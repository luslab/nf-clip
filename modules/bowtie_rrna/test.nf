#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for Bowtie Pre-mapping to rRNA and tRNA")

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.bowtie_index = [["$baseDir/input/small_rna_bowtie"]]

/*-------------------------------------------------------------------------------------*/
/* Module inclusions 
--------------------------------------------------------------------------------------*/

include bowtie_rrna from './bowtie_rrna.nf'

/*------------------------------------------------------------------------------------*/
/* Define input channels
/*------------------------------------------------------------------------------------*/

testMetaDataFq = [
  ['Sample1', "$baseDir/input/prpf8_ctrl_rep1.fq.gz"],
  ['Sample2', "$baseDir/input/prpf8_ctrl_rep2.fq.gz"],
  ['Sample3', "$baseDir/input/prpf8_ctrl_rep4.fq.gz"],
  ['Sample4', "$baseDir/input/prpf8_eif4a3_rep1.fq.gz"],
  ['Sample5', "$baseDir/input/prpf8_eif4a3_rep2.fq.gz"],
  ['Sample6', "$baseDir/input/prpf8_eif4a3_rep4.fq.gz"]
]

// bowtie index channel
  Channel
  .from(params.bowtie_index)
  .map { row -> file(row[0], checkIfExists: true)}
  .set {ch_test_bowtie_index}

//Fq input channel
  Channel
  .from(testMetaDataFq)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .combine( ch_test_bowtie_index )
  .set {ch_test_meta_fq}

/*------------------------------------------------------------------------------------*/
/* Run the workflow
/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run pre-map
    bowtie_rrna(ch_test_meta_fq)

    // Collect file names and view output
    bowtie_rrna.out.rrnaBam | view
    bowtie_rrna.out.unmappedFq | view
}

