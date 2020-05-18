#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'fastqc'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = './results'
params.internal_process_name = 'fastqc'

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

/*-------------------------------------------------> FASTQC PARAMETERS <-----------------------------------------------------*/

/*---------------------------------------------------------------------------------------------------------------------------*/

process fastqc {
  publishDir "${params.internal_outdir}/${params.internal_process_name}",
    mode: "copy", overwrite: true

    input:
      tuple val(sample_id), path(reads)

    output:
      tuple val(sample_id), path ("*_fastqc.{zip,html}"), emit: report

    script:
    """
    fastqc --threads ${task.cpus} $reads
    """
}