#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting STAR module")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include star from './star.nf' addParams(star_custom_args: "--outSAMtype BAM SortedByCoordinate --readFilesCommand zcat")

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

params.genome_index = "$baseDir/input/reduced_star_index"

testMetaData = [
  ['Sample1', "$baseDir/input/zipped_reads/prpf8_eif4a3_rep1.Unmapped.fq.gz"],
  ['Sample2', "$baseDir/input/zipped_reads/prpf8_eif4a3_rep2.Unmapped.fq.gz"]
]

 Channel
    .from( testMetaData )
    .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .combine( Channel.fromPath( params.genome_index ) )
    .set { ch_testData }

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run star
    star( ch_testData )

    // Collect file names and view output
    //star.out | view
}
