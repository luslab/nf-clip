#!/usr/bin/env nextflow
/*
========================================================================================
                         luslab/group-nextflow-clip
========================================================================================
Luscombe lab CLIP analysis pipeline.
 #### Homepage / Documentation
 https://github.com/luslab/group-nextflow-clip
----------------------------------------------------------------------------------------
*/

// Define DSL2
nextflow.preview.dsl=2

/* Module inclusions 
--------------------------------------------------------------------------------------*/

include luslabHeader from './modules/overhead/overhead'
include fastqc as prefastqc from './modules/fastqc/pre-fastqc.nf'
include fastqc as postfastqc from './modules/fastqc/pre-fastqc.nf' 
include cutadapt from './modules/trim-reads/trim-reads.nf'
include bowtie_rrna from './modules/pre-map/pre-map.nf'
include genomemap from './modules/genome-map/genome-map.nf'


/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

params.reads = "$baseDir/test/reads/*.fq.gz"
params.bowtie_index = "$baseDir/test/small_rna_bowtie"
params.star_index = "$baseDir/test/reduced_star_index"

/*------------------------------------------------------------------------------------*/

// Run workflow
log.info luslabHeader()
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    ch_bowtieIndex = Channel.fromPath( params.bowtie_index )
    ch_starIndex = Channel.fromPath( params.star_index )

    // Run fastqc
    prefastqc( ch_testData )
    //Run read trimming
    cutadapt( ch_testData )
    // Run post-trim fastqc
    postfastqc( cutadapt.out )
    // pre-map to rRNA and tRNA
    bowtie_rrna( cutadapt.out, ch_bowtieIndex )
    // map unmapped reads to the genome
    // genomemap( bowtie_rrna.out.groupTuple(), ch_starIndex )

    // Collect file names and view output
    //prefastqc.out.collect() | view
    //genomemap.out.collect() | view
    bowtie_rrna.out.collect() | view
    
}
/*------------------------------------------------------------------------------------*/
