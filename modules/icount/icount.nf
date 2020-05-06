#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'icount'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'icount'

//Prefix to define the output file 
params.internal_output_prefix = ''

/*-------------------------------------------------> iCOUNT PARAMETERS <-----------------------------------------------------*/

/*-----------------------------------------------------------------------------------------------------------------------------
CUSTOM PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

//Add custom arguments
//Copy-paste the desired option in the empty brackets, it will automatically be added to the process.

/*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

// Trimming reusable component
process icount {
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
    
    //Combining the custom arguments and creating cutadapt args
    internal_default_paired_end_args = ''
    internal_custom_args = "$params.internal_action_args$params.internal_paired_end_filter_args"
    cutadapt_args = "$internal_custom_args "
    

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

    //Determines if there a single or multiple adapters
    if (params.internal_multiple_adapters == false){
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
    }else {
        if (params.internal_3_trim_multiple){
            cutadapt_args += "-a file:$params.internal_multi_adapt_fasta "
        }
        if (params.internal_5_trim_multiple){
            cutadapt_args += "-g file:$params.internal_multi_adapt_fasta "
        }
        if (params.internal_3_or_5_trim_multiple){
            cutadapt_args += "-b file:$params.internal_multi_adapt_fasta "
        }
    } 
    //TODO: include trimming options: non-internal and anchored adapters for -a and -g in multiple adapters


    //Filtering params
    if (params.internal_min_length > 0){
        cutadapt_args += "-m $params.internal_min_length "
    }
    if (params.internal_max_length != 0){
        cutadapt_args += "-M $params.internal_max_length "
    }
    if (params.internal_discard_trimmed){
        cutadapt_args += "--discard-trimmed "
    }
    if (params.internal_discard_untrimmed){
        cutadapt_args += "--discard-untrimmed "
    }
    if (params.internal_too_short_output != ''){
        cutadapt_args += "--too-short-output $params.internal_too_short_output "
    }
    if (params.internal_too_long_output != ''){
        cutadapt_args += "--too-long-output $params.internal_too_long_output "
    }
    if (params.internal_untrimmed_output != ''){
        cutadapt_args += "--untrimmed-output $params.internal_untrimmed_output "
    }
    if (params.internal_max_n_bases != 0){
        cutadapt_args += "--max-n $params.internal_max_n_bases "
    }
    if (params.internal_max_expected_errors != 0){
        cutadapt_args += "--max-expected-errors $params.internal_max_expected_errors "
    }
    if (params.internal_discard_casava){
        cutadapt_args += "--discard-casava $params.internal_discard_casava "
    }

    //Outputs and inputs
    if (params.internal_output_prefix != null){
        cutadapt_args += "-o ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz "   
    }

    //Paired-end mode -> determining paired output + inputs (forward and reverse)
    if (params.internal_paired_end_mode){
        internal_default_paired_end_args += "-p ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz "
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
