#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.fastqc_processname = 'fastqc'

// fastqc reusable component
process fastqc {
  publishDir "${params.outdir}/${params.fastqc_processname}",
    mode: "copy", overwrite: true

    input:
      path reads

    output:
      path "*_fastqc.{zip,html}", emit: report

    script:
    """
    fastqc --quiet --threads $task.cpus $reads
    """
}