#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting Samtools module")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include samtools from './samtools.nf' //addParams(star_custom_args: "-t 2")

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

testMetaData = [
  ['Sample1', "$baseDir/input/prpf8_eif4a3_rep1.Unmapped.fqAligned.sortedByCoord.out.bam"],
  ['Sample2', "$baseDir/input/prpf8_eif4a3_rep2.Unmapped.fqAligned.sortedByCoord.out.bam"]
]

 Channel
    .from( testMetaData )
    .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .set { ch_testData }

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run star
    samtools( ch_testData )

    // Collect file names and view output
    samtools.out | view
}
