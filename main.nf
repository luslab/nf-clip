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

/*-----------------------------------------------------------------------------------------------------------------------------
Module global params
-------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------
Module inclusions
-------------------------------------------------------------------------------------------------------------------------------*/

include luslabHeader from './modules/overhead/overhead'
include metadata from './modules/metadata/metadata.nf'
include fastqc as prefastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'pre_fastqc') 
include fastqc as postfastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'post_fastqc') 
include cutadapt from './modules/cutadapt/cutadapt.nf'
include bowtie_rrna from './modules/bowtie_rrna/bowtie_rrna.nf'


include dedup from './modules/deduplicate-bam/deduplicate-bam.nf'
include getcrosslinks from './modules/get-crosslinks/get-crosslinks.nf'
include getcrosslinkcoverage from './modules/get-crosslink-coverage/get-crosslink-coverage.nf'
include icount from './modules/icount/icount.nf'
include multiqc from './modules/multiqc/multiqc.nf'

/*-----------------------------------------------------------------------------------------------------------------------------
Params
-------------------------------------------------------------------------------------------------------------------------------*/

params.results = "$baseDir/test/data/results" // output directory
params.umidedup = false // Switch for uni dedup

// Main data parameters
params.input = "$baseDir/test/data/metadata.csv"
params.bowtie_index = "$baseDir/test/data/small_rna_bowtie"
params.star_index = "$baseDir/test/data/reduced_star_index"
params.genome_fai = "$baseDir/test/data/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"
params.segmentation = "?????"

/*-----------------------------------------------------------------------------------------------------------------------------
Main pipeline
-------------------------------------------------------------------------------------------------------------------------------*/

// Show banner
log.info luslabHeader()

// Run workflow
workflow {

    // Create channels for indices
    ch_bowtieIndex = Channel.fromPath( params.bowtie_index )
    ch_starIndex = Channel.fromPath( params.star_index )
    ch_genomeFai = Channel.fromPath( params.genome_fai )
    ch_segmentation = Channel.fromPath (params.segmentation)

    // Get fastq paths 
    metadata( params.input )

    // Run fastqc
    prefastqc( metadata.out.data )
    
    //Run read trimming
    cutadapt( metadata.out.data )

    // Run post-trim fastqc
    postfastqc( cutadapt.out.trimmedReads )
    
    // pre-map to rRNA and tRNA
    bowtie_rrna( cutadapt.out.trimmedReads, ch_bowtieIndex )


    
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
    
    // iCount peak call
    icount ( getcrosslinks.out, ch_segmentation )

    // Collect all data for multiqc
    ch_multiqc_input = prefastqc.out.report.mix(
        postfastqc.out.report
    ).collect()

    multiqc(ch_multiqc_input)
}


workflow.onComplete {
    log.info "\nPipeline complete!\n"
}

/*------------------------------------------------------------------------------------*/