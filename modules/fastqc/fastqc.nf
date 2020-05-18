#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.fastqc_processname = 'fastqc'

/*-------------------------------------------------> FASTQC PARAMETERS <-----------------------------------------------------*/


/*-----------------------------------------------------------------------------------------------------------------------------
ADDITIONAL OPTIONS PARAMETERS
-------------------------------------------------------------------------------------------------------------------------------*/

//Create all output files in the specified output directory. Please note that this directory must exist as the program will not create it.
//params.internal_outdir = ''

//Files come from raw casava output.
//params.internal_casava = false

//

// fastqc reusable component
process fastqc {
  publishDir "${params.outdir}/${params.fastqc_processname}",
    mode: "copy", overwrite: true

    input:
      tuple val(sample_id), path(reads)

    output:
      tuple val(sample_id), path ("*_fastqc.{zip,html}"), emit: report

    shell:
    """
    fastqc --quiet --threads ${task.cpus} $reads
    """
}