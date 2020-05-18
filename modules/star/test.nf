#!/usr/bin/env nextflow

// Define DSL2
nextflow.preview.dsl=2

// Log
log.info ("Starting STAR module")

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include star from './star.nf' addParams(star_custom_args: 
      "--runThreadN 2 \
      --genomeLoad NoSharedMemory \
      --outFilterMultimapNmax 1 \
      --outFilterMultimapScoreRange 1 \
      --outSAMattributes All \
      --alignSJoverhangMin 8 \
      --alignSJDBoverhangMin 1 \
      --outFilterType BySJout \
      --alignIntronMin 20 \
      --alignIntronMax 1000000 \
      --outFilterScoreMin 10  \
      --alignEndsType Extend5pOfRead1 \
      --twopassMode Basic \
      --outSAMtype BAM SortedByCoordinate \
      --limitBAMsortRAM 6000000000")

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

params.genome_index = "$baseDir/input/reduced_star_index"

testMetaData = [
  ['Sample1', "$baseDir/input/prpf8_eif4a3_rep1.Unmapped.fq"],
  ['Sample2', "$baseDir/input/prpf8_eif4a3_rep2.Unmapped.fq"]
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
