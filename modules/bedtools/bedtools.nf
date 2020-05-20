#!/usr/bin/env nextflow

// Define default nextflow internals
params.internal_outdir = params.outdir
params.internal_process_name = 'bedtools_intersect'

//Prefix to define the output file 
params.internal_output_prefix = ''


process bedtools_intersect {

    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input: 

    output: 

    shell:
    """
    bedtools intersect -a BED -b regions.gtf.gz -wa -wb -s > ANNOTATED
    """


}