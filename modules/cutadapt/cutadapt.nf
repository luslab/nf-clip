#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File("groovy/NfUtils.groovy"));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'cutadapt'

// Specify DSL2
nextflow.preview.dsl = 2

// TODO check version of cutadapt in host process --> CUTADAPT 2.6 (latest is 2.9)

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'cutadapt'

//Prefix to define the output file 
params.internal_output_prefix = ''

/*-----------------------------------------------------------------------------------------------------------------------------
---> CUTADAPT PARAMETERS 
-------------------------------------------------------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------
REPORTING PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/
//Suppress all output except error messages
params.internal_quiet = false

//Provides the GC content (as percentage) of the reads
params.internal_gc_content = 0

//Detailed information about where adapters were found in each read are written to the given file
params.internal_info_file = ''

//Report type changed to a one-line summary
params.internal_min_report = false

/*-----------------------------------------------------------------------------------------------------------------------------
BASIC PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

//Trims low-quality ends from reads
params.internal_min_quality = 10

/*Discard processed reads that are shorter than a certain length
To avoid issues with zero-length sequences, specify at least "-m 1" */
params.internal_min_length = 16

//Disallow insertions and deletions entirely
params.internal_no_indels = true

//Determines the maximum error rate for a specific adaptor
params.internal_max_error_rate = 0

//Changes the minimum overlap length for all parameters
params.internal_min_overlap = 0

/*Unconditionally removes bases from the beginning or end of each read. If the given length is positive,
the bases are removed from the beginning of each read. If it is negative, the bases are removed from the end.*/
params.internal_cut = 7

// ONLY AVAILABLE IN VERSION 2.8 AND ON SINGLE-END DATA
//Cutadapt searches both the read and its reverse complement for adapters
//params.internal_rev_comp = true

/*-----------------------------------------------------------------------------------------------------------------------------
ADAPTER SEQUENCES PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/
//Single adapter sequence
//Automatically removes 3' adapters if not specified otherwise
params.internal_adapter_sequence = 'AGATCGGAAGAGC'

//Multiple adapter sequences
//def myAdapters = []
//myAdapters[0] = 'AGATCGGAAGAGC'

/*-----------------------------------------------------------------------------------------------------------------------------
SINGLE ADAPTER TRIMMING PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

//Removes 3' adapters --> DEFAULT OPTION
params.internal_3_trim = true

//Removes 5' adapters
params.internal_5_trim = false

//Can remove either 3' or 5' adapters
params.internal_3_or_5_trim = false

//Disallows internal matches for a 3’ adapter
params.internal_non_intern_3_trim = false

//Disallows internal matches for a 5' adapter
params.internal_non_intern_5_trim = false

//Anchors a 3' adapter to the end of the read
params.internal_anchor_3_trim = false

//Anchors a 5' adapter to the end of the read
params.internal_anchor_5_trim = false


/*-----------------------------------------------------------------------------------------------------------------------------
FILTERING PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

//Changes level of compression to 1
params.internal_comp_level_to_1 = false

//Discard reads in which no adapter was found. This has the same effect as specifying --untrimmed-output /dev/null.
//params.internal_discard_untrimmed = true

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

// Trimming reusable component
process cutadapt {
    // Tag
    tag "${sample_id}"

    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
        //tuple val(sample_id), path(reads)
        path(reads)

    output:
        //tuple val(sample_id), path("${reads.simpleName}.trimmed.fq.gz")
        path("${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz")

    shell:
    
    cutadapt_args = ''

    //Report types if-statements
    if (params.internal_quiet){
        cutadapt_args += "--quiet "
    }
    if (0 < params.internal_gc_content << 100){
        cutadapt_args += "--gc-content=$params.internal_gc_content "
    }
    if (params.internal_info_file != ''){
        cutadapt_args += "--info-file $params.internal_info_file "
    }
    if (params.internal_min_report){
        cutadapt_args += "--report=minimal "
    }

    //Basic parameters if-statements 
    if (params.internal_min_quality > 0){
        cutadapt_args += "-q $params.internal_min_quality "
    }
    if (params.internal_min_length > 0){
        cutadapt_args += "-m $params.internal_min_length "
    }
    if (params.internal_no_indels){
        cutadapt_args += "--no-indels "
    }
    if (params.internal_max_error_rate > 0){
        cutadapt_args += "-e $params.internal_max_error_rate "
    }
    if (params.internal_min_overlap > 0){
        cutadapt_args += "-0 ${params.internal_min_overlap} "
    }
    if (params.internal_cut != 0){
        cutadapt_args += "-u $params.internal_cut "
    }
    /*if (params.internal_rev_comp){
        cutadapt_args += "--rc "
    } */
    
    //Adapter trimming if-statements
    if (params.internal_3_trim){
        cutadapt_args += "-a $params.internal_adapter_sequence "
    }
    if (params.internal_5_trim){
        cutadapt_args += "-g $params.internal_adapter_sequence "
    }
    if (params.internal_3_or_5_trim){
        cutadapt_args += "-b $params.internal_adapter_sequence "
    }
    if (params.internal_non_intern_3_trim){
       X = "X"
        cutadapt_args += "-a $params.internal_adapter_sequence$X "
    }
    if (params.internal_non_intern_5_trim){
        cutadapt_args += "-g X$params.internal_adapter_sequence "
    }
    if (params.internal_anchor_3_trim){
        cutadapt_args += "-a $params.internal_adapter_sequence\$ "
    }
    if (params.internal_anchor_5_trim){
        cutadapt_args += "-g ^$params.internal_adapter_sequence "
    }

    /*if (params.internal_discard_untrimmed){
      cutadapt_args += "--discard-untrimmed $params.internal_discard_untrimmed "
    } */
    if (params.internal_output_prefix != null){
        cutadapt_args += "-o ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz "
    }
    
    
    // Displays the cutadapt command line (cutadapt_args) to check for mistakes
    println cutadapt_args

    """
    cutadapt $cutadapt_args $reads
    
    """

    /*"""
    cutadapt \
        -j ${task.cpus} \
        -q ${params.internal_min_quality} \
        --minimum-length ${params.internal_min_length} \
        -a ${params.internal_adapter_sequence} \
        -o ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz $reads 
    """ */
}
