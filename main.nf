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

// /* Module inclusions 
// --------------------------------------------------------------------------------------*/

// include luslabHeader from './modules/overhead/overhead'
// include metadata from './modules/metadata/metadata.nf'
// include fastqc as prefastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'pre_fastqc') 
// include fastqc as postfastqc from './modules/fastqc/fastqc.nf' params(fastqc_processname: 'post_fastqc') 
// include cutadapt from './modules/cutadapt/cutadapt.nf'
// include bowtie_rrna from './modules/pre-map/pre-map.nf'
// include star as genomemap from './modules/genome-map/genome-map.nf'
// include sambamba from './modules/genome-map/genome-map.nf'
// include rename_files from './modules/genome-map/genome-map.nf'
// include merge_pairId_bam from './modules/deduplicate-bam/deduplicate-bam.nf'
// include dedup from './modules/deduplicate-bam/deduplicate-bam.nf'
// include getcrosslinks from './modules/get-crosslinks/get-crosslinks.nf'
// include getcrosslinkcoverage from './modules/get-crosslink-coverage/get-crosslink-coverage.nf'
// include multiqc from './modules/multiqc/multiqc.nf'

// /*------------------------------------------------------------------------------------*/
// /* Params
// --------------------------------------------------------------------------------------*/

// params.input = "$baseDir/test/data/metadata.csv"
// params.umidedup = false
// // params.input = "metadata.csv"

// //params.reads = "$baseDir/test/data/reads/*.fq.gz"
// //params.bowtie_index = "$baseDir/test/data/small_rna_bowtie"
// //params.star_index = "$baseDir/test/data/reduced_star_index"
// //params.genome_fai = "$baseDir/test/data/GRCh38.primary_assembly.genome_chr6_34000000_35000000.fa.fai"
// //params.results = "$baseDir/test/data/results"

// /*------------------------------------------------------------------------------------*/

// // Run workflow
// log.info luslabHeader()
// workflow {

//     // Create channels for indices
//     ch_bowtieIndex = Channel.fromPath( params.bowtie_index )
//     ch_starIndex = Channel.fromPath( params.star_index )
//     ch_genomeFai = Channel.fromPath( params.genome_fai )

//     // Get fastq paths 
//     metadata( params.input )

//     // Run fastqc
//     prefastqc( metadata.out )
    
//     //Run read trimming
//     cutadapt( metadata.out )

//     // Run post-trim fastqc
//     postfastqc( cutadapt.out )
    
//     // pre-map to rRNA and tRNA
//     bowtie_rrna( cutadapt.out, ch_bowtieIndex )
    
//     // map unmapped reads to the genome
//     genomemap( bowtie_rrna.out.unmappedFq, ch_starIndex )
    
//     // Indexing the genome
//     sambamba ( genomemap.out.bamFiles )
    
//     // Renaming to .bai files
//     rename_files ( sambamba.out.baiFiles, genomemap.out.bamFiles )
    
//     if ( params.umidedup ) {
//         // Merging bam and bai
//         merge_pairId_bam ( genomemap.out.bamFiles, rename_files.out.renamedBaiFiles,  genomemap.out.pairId )
        
//         // PCR duplicate removal (optional)
//         dedup( merge_pairId_bam.out.bamPair.join(merge_pairId_bam.out.baiPair) )
        
//         // get crosslinks from bam
//         getcrosslinks( dedup.out.dedupBam, ch_genomeFai )
//     } else {
//         // get crosslinks from bam
//         getcrosslinks( genomemap.out.bamFiles, ch_genomeFai )
//     }
    
//     // normalise crosslinks + get bedgraph files
//     getcrosslinkcoverage( getcrosslinks.out)
    
//     ch_multiqc_input = prefastqc.out.report.mix(
//     //    cutadapt.out.report,
//         postfastqc.out.report
//       //  bowtie_rrna.out.report
//        // genomemap.out.report,
//         //getcrosslinks.out.report,
//         //getcrosslinkcoverage.out.report
//     ).collect()


//     multiqc(ch_multiqc_input)
// }


// workflow.onComplete {
//     log.info "\nPipeline complete!\n"
// }

// /*------------------------------------------------------------------------------------*/
// Fudge to get this working on CAMP

// Log
log.info ("Starting icount trimming test pipeline")

/* Define global params
--------------------------------------------------------------------------------------*/


/* Module inclusions 
--------------------------------------------------------------------------------------*/

include icount from '/camp/home/chakraa2/working/nobby/projects/nextflow/icount.nf'

/*------------------------------------------------------------------------------------*/
/* Define input channels
--------------------------------------------------------------------------------------*/

testMetaData = [
  ['Sample 1', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_ctrl_rep1.xl.bed.gz"],
  ['Sample 2', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_ctrl_rep2.xl.bed.gz"],
  ['Sample 3', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_ctrl_rep4.xl.bed.gz"],
  ['Sample 4', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_eif4a3_rep1.xl.bed.gz"],
  ['Sample 5', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_eif4a3_rep2.xl.bed.gz"],
  ['Sample 6', "/camp/home/chakraa2/working/nobby/projects/nextflow/input/prpf8_eif4a3_rep4.xl.bed.gz"]
]

testSegPath = [
  ["/camp/home/chakraa2/working/nobby/projects/nextflow/input/segmentation.gtf.gz"]
]

// Create channels of test data 
Channel
  .from(testSegPath)
  .map { row -> file(row[0], checkIfExists: true) }
  .set {ch_test_seg}

  Channel
  .from(testMetaData)
  .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
  .combine(ch_test_seg)
  .set {ch_test_meta}

/*------------------------------------------------------------------------------------*/

// Run workflow
workflow {
    icount( ch_test_meta ).view()
}