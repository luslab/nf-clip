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
include fastqc as prefastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'pre_fastqc') 
include fastqc as postfastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'post_fastqc') 
include cutadapt from './modules/cutadapt/cutadapt.nf'
include bowtie_rrna from './modules/pre-map/pre-map.nf'
include star as genomemap from './modules/genome-map/genome-map.nf'
include sambamba from './modules/genome-map/genome-map.nf'
include rename_files from './modules/genome-map/genome-map.nf'
include merge_pairId_bam from './modules/deduplicate-bam/deduplicate-bam.nf'
include dedup from './modules/deduplicate-bam/deduplicate-bam.nf'
include getcrosslinks from './modules/get-crosslinks/get-crosslinks.nf'
include getcrosslinkcoverage from './modules/get-crosslink-coverage/get-crosslink-coverage.nf'

/*------------------------------------------------------------------------------------*/
/* Params
--------------------------------------------------------------------------------------*/

//params.reads = "$baseDir/test/data/reads/*.fq.gz"
//params.bowtie_index = "$baseDir/test/data/small_rna_bowtie"
//params.star_index = "$baseDir/test/data/reduced_star_index"
//params.genome_fai = "$baseDir/test/data/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"
//params.results = "$baseDir/test/data/results"

/*------------------------------------------------------------------------------------*/

// Run workflow
log.info luslabHeader()
workflow {
    // Create test data channel from all read files
    ch_testData = Channel.fromPath( params.reads )
    ch_bowtieIndex = Channel.fromPath( params.bowtie_index )
    ch_starIndex = Channel.fromPath( params.star_index )
    ch_genomeFai = Channel.fromPath( params.genome_fai )

    // Run fastqc
    prefastqc( ch_testData )
    //Run read trimming
    cutadapt( ch_testData )
    // Run post-trim fastqc
    postfastqc( cutadapt.out )
    // pre-map to rRNA and tRNA
    bowtie_rrna( cutadapt.out, ch_bowtieIndex )
    // map unmapped reads to the genome
    genomemap( bowtie_rrna.out.unmappedFq, ch_starIndex )
    // Indexing the genome
    sambamba ( genomemap.out.bamFiles )
    // Renaming to .bai files
    rename_files ( sambamba.out.baiFiles, genomemap.out.bamFiles )
    if ( params.umidedup ) {
        // Merging bam and bai
        merge_pairId_bam ( genomemap.out.bamFiles, rename_files.out.renamedBaiFiles,  genomemap.out.pairId )
        // PCR duplicate removal (optional)
        dedup( merge_pairId_bam.out.bamPair.join(merge_pairId_bam.out.baiPair) )
        // get crosslinks from bam
        getcrosslinks( dedup.out.dedupBam, ch_genomeFai )
    } else {
        // get crosslinks from bam
        getcrosslinks( genomemap.out.bamFiles, ch_genomeFai )
    }
    // normalise crosslinks + get bedgraph files
    getcrosslinkcoverage( getcrosslinks.out)
}

workflow.onComplete {
    log.info "\nPipeline complete!\n"
}

/*------------------------------------------------------------------------------------*/
