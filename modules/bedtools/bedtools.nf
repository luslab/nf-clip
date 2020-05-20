#!/usr/bin/env nextflow

// Include NfUtils
//Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
//GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'bedtools'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = params.outdir
params.internal_process_name = 'bedtools'

// Check if globals need to 
//nfUtils.check_internal_overrides(module_name, params)

process bedtools_intersect {

    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input: 
        tuple val(sample_id), path(reads)

    output: 
        tuple val(sample_id), path("${reads.simpleName}.bed"), emit: annotatedBed

    shell:
    """
    bedtools intersect -a regions_GENCODE_v30.gtf.gz -b $reads -wa -wb -s > ${reads.simpleName}.annotated.bam
    """
}