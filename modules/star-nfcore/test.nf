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

params.reads = "$baseDir/input/zipped_reads/*.fq.gz"
//params.reads = "$baseDir/input/*.fq"
params.genome_index = "$baseDir/input/reduced_star_index"

ch_testData = Channel.fromPath( params.reads )
ch_testIndex = Channel.fromPath( params.genome_index )

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    // Run star
    star( ch_testData, ch_testIndex  )

    // Collect file names and view output
    //star.out | view
}
