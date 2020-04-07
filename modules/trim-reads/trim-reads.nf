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
params.internal_output_prefix = ''
params.internal_min_quality = 10
params.internal_min_length = 16
params.internal_adapter_sequence = 'AGATCGGAAGAGC'

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
    """
    cutadapt \
        -j ${task.cpus} \
        -q ${params.internal_min_quality} \
        --minimum-length ${params.internal_min_length} \
        -a ${params.internal_adapter_sequence} \
        -o ${params.internal_output_prefix}${reads.simpleName}.trimmed.fq.gz $reads
    """
}