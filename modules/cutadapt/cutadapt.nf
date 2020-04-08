#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File("groovy/NfUtils.groovy"));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'cutadapt'

// Specify DSL2
nextflow.preview.dsl = 2

// TODO check version of cutadapt in host process

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'cutadapt'

//Trims low-quality ends from reads
params.internal_min_quality = 10

/*Discard processed reads that are shorter than a certain length
To avoid issues with zero-length sequences, specify at least "-m 1" */
params.internal_min_length = 16

//Adapter sequence
//Automatically removes 3' adapters if not specified otherwise
//def myAdapters = []
//myAdapters[0] = 'AGATCGGAAGAGC'
params.internal_adapter_sequence = 'AGATCGGAAGAGC'

//Prefix to define the output file 
params.internal_output_prefix = ''

//Removes 5' adapters
params.internal_5_trim = false

//Can remove either 3' or 5' adapters
params.internal_3_or_5_trim = false

//Changes the minimum overlap length for all parameters
params.internal_min_overlap = 0

//Discards untrimmed reads
params.internal_discard_untrimmed = false

/*//Determines the maximum error rate for a specific adaptor
//params.internal_max_error_rate = 0

//Changes level of compression to 1
params.internal_comp_level_to_1 = false


//Provides the GC content (as percentage) of the reads
params.internal_gc_content = false

//Disallow insertions and deletions entirely
params.internal_no_delete_no_insert = false

//Unconditional base removal
params.internal_cut = false 

//Detailed information about where adapters were found in each read are written to the given file
params.internal_info_file = false */

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

    if (params.internal_min_quality > 0){
        cutadapt_args += "-q $params.internal_min_quality "
    }
    if (params.internal_min_length > 0){
        cutadapt_args += "--minimum-length $params.internal_min_length "
    }
    if (params.internal_adapter_sequence != null){
        cutadapt_args += " -a $params.internal_adapter_sequence "
        if (params.internal_5_trim){
            cutadapt_args += "-g $params.internal_adapter_sequence "
        }
        if (params.internal_3_or_5_trim){
            cutadapt_args += "-b $params.internal_adapter_sequence "
        }
    }
    if (params.internal_output_prefix != null){
        cutadapt_args += "-o ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz "
    }
    if (params.internal_min_overlap > 0){
        cutadapt_args += "-0 ${params.internal_min_overlap} "
    }
    

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