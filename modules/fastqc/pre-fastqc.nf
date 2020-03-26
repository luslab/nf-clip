#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process fastqc {
    input:
      path reads

    output:
      file "*_fastqc.{zip,html}"

    script:
    """
    fastqc --quiet --threads $task.cpus $reads
    """
}