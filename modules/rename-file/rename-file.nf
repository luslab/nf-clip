#!/usr/bin/env nextflow

/*-----------------------------------------------------------------------------------------------------------------------------
INIT
-------------------------------------------------------------------------------------------------------------------------------*/

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'rename_file'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = params.outdir
params.internal_process_name = 'rename_file'

/*-----------------------------------------------------------------------------------------------------------------------------
PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

params.internal_prefix = '' // Define prefix for output files
params.internal_ext = '.notspecified' // Define new extension for the output files

// Check for globals
nfUtils.check_internal_overrides(module_name, params)

/*-----------------------------------------------------------------------------------------------------------------------------
MODULE
-------------------------------------------------------------------------------------------------------------------------------*/

process rename_file {
    tag "${sample_id}"

    input:
      tuple val(sample_id), path(input_file)

    output:
      tuple val(sample_id), path("${params.internal_prefix}${input_file.simpleName}${params.internal_ext}"), emit: renamedFiles

    shell:
    """
    mv $input_file ${params.internal_prefix}${input_file.simpleName}${params.internal_ext}
    """
}