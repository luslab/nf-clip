#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting rename file test pipeline")

/* Define global params
--------------------------------------------------------------------------------------*/

params.rename_file_ext = '.testext'

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include rename_files from './rename-file.nf'

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

testPaths = [
  ['test1', "$baseDir/input/test1.fq"],
  ['test2', "$baseDir/input/test2.fq.gz"],
  ['test3', "$baseDir/input/test3.xl.bed.gz"]
]

 Channel
  .from(testPaths)
  .map { row -> [ row[0], file(row[1]) ] }
  .set {ch_test_inputs}

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    rename_files(ch_test_inputs)

    rename_files.out.renamedFiles | view
}