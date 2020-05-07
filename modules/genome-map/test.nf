#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting test pipeline for genome mapping")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include genomemap from './genome-map.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/input/*.fq"
params.genome_index = "$baseDir/input/reduced_star_index"

/*testMetaData = [
  ['Sample 1', "$baseDir/input/readfile1.fq.gz"],
  ['Sample 2', "$baseDir/input/readfile2.fq.gz"],
  ['Sample 3', "$baseDir/input/readfile3.fq.gz"],
  ['Sample 4', "$baseDir/input/readfile4.fq.gz"],
  ['Sample 5', "$baseDir/input/readfile5.fq.gz"],
  ['Sample 6', "$baseDir/input/readfile6.fq.gz"]
] */

/* Create channels of test data 
 Channel
  .from(testMetaData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .set {ch_test_meta} */

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    ch_testIndex = Channel.fromPath( params.genome_index )
    
    // Run star
    genomemap( ch_testData, ch_testIndex )
    // genomemap( ch_test_meta, ch_testIndex)

    // Collect file names and view output
    genomemap.out.collect() | view
}