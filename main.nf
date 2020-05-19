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
Global init
-------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------
Module global params
-------------------------------------------------------------------------------------------------------------------------------*/

params.cutadapt_max_error_rate = 0.1
params.rename_file_ext = '.bai'

/*-----------------------------------------------------------------------------------------------------------------------------
Module inclusions
-------------------------------------------------------------------------------------------------------------------------------*/

include luslabHeader from './modules/util/util.nf'
include metadata from './modules/metadata/metadata.nf'
include fastqc as prefastqc from './modules/fastqc/fastqc.nf' addParams(fastqc_process_name: 'pre_fastqc') 
include fastqc as postfastqc from './modules/fastqc/fastqc.nf' addParams(fastqc_process_name: 'post_fastqc') 
include cutadapt from './modules/cutadapt/cutadapt.nf'
include bowtie_rrna from './modules/bowtie_rrna/bowtie_rrna.nf'
include rename_file from './modules/rename-file/rename-file.nf'
include samtools from './modules/samtools/samtools.nf'
include umi_tools from './modules/umi-tools/umi-tools.nf'
include getcrosslinks from './modules/get-crosslinks/get-crosslinks.nf'
include getcrosslinkcoverage from './modules/get-crosslink-coverage/get-crosslink-coverage.nf'
include icount from './modules/icount/icount.nf'
include paraclu from './modules/paraclu/paraclu.nf'
include peka from './modules/peka/peka.nf'
include multiqc from './modules/multiqc/multiqc.nf'

include star from './modules/star/star.nf' addParams(star_custom_args: 
      "--genomeLoad NoSharedMemory \
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
      --outSAMtype BAM SortedByCoordinate")

/*-----------------------------------------------------------------------------------------------------------------------------
Pipeline params
-------------------------------------------------------------------------------------------------------------------------------*/

params.umidedup = true // Switch for umi dedup

// Main data parameters
params.input = ''
params.bowtie_index = ''
params.star_index = ''
params.genome = ''
params.genome_fai = ''
params.segmentation = ''
params.peka_regions = ''

/*-----------------------------------------------------------------------------------------------------------------------------
Main workflow
-------------------------------------------------------------------------------------------------------------------------------*/

// Show banner
log.info luslabHeader()

// Run workflow
workflow {

    // Create channels for static files
    ch_bowtieIndex = Channel.fromPath( params.bowtie_index )
    ch_starIndex = Channel.fromPath( params.star_index )
    ch_genome = Channel.fromPath( params.genome )
    ch_genomeFai = Channel.fromPath( params.genome_fai )
    ch_segmentation = Channel.fromPath ( params.segmentation )
    ch_regions = Channel.fromPath ( params.peka_regions )

    // Get fastq paths 
    metadata( params.input )

    // Run fastqc
    prefastqc( metadata.out.data )
    
    //Run read trimming
    cutadapt( metadata.out.data )

    // Run post-trim fastqc
    postfastqc( cutadapt.out.trimmedReads )
    
    // pre-map to rRNA and tRNA
    bowtie_rrna( cutadapt.out.trimmedReads.combine(ch_bowtieIndex) )
    
    // Align
    star( bowtie_rrna.out.unmappedFq.combine(ch_starIndex) )
   
    // Index the bam files
    samtools( star.out.bamFiles )
    
    // Rename the bai files
    //rename_file( samtools.out.baiFiles )
    
    if ( params.umidedup ) {
        // PCR duplicate removal (optional)
        umi_tools( samtools.out.baiFiles.join( star.out.bamFiles ) )

        // get crosslinks from bam
        getcrosslinks( umi_tools.out.dedupBam.combine(ch_genomeFai) )
    } else {
        // get crosslinks from bam
        getcrosslinks( star.out.bamFiles.combine(ch_genomeFai) )
    }

    // normalise crosslinks + get bedgraph files
    getcrosslinkcoverage( getcrosslinks.out.crosslinkBed )
    
    paraclu(getcrosslinks.out.crosslinkBed)

    //kmers analysis
    ch_peka_input = paraclu.out.peaks.join(getcrosslinks.out.crosslinkBed)
                        .combine(ch_genome)
                        .combine(ch_genomeFai)
                        .combine(ch_regions)

    peka( ch_peka_input )

    // iCount peak call
    icount ( getcrosslinks.out.crosslinkBed.combine(ch_segmentation) )

    // Collect all data for multiqc
    //ch_multiqc_input = prefastqc.out.report.mix(
    //    postfastqc.out.report
    //).collect()

    //multiqc(ch_multiqc_input)
}

workflow.onComplete {
    log.info "\nPipeline complete!\n"
}

/*------------------------------------------------------------------------------------*/