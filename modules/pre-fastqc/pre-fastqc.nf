#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

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

 workflow prefastqc {
    take: inputReads
    main:
      fastqc(inputReads)
    emit:
      fastqc.out
}