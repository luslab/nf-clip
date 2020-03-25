#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Trimming reusable component
process trimreads {
    input:
        path reads

    output:
        file "trimmed_reads*"

    shell:
    """
    trimgalore --quiet --threads 
    """
}

workflow trimreads {
    take: 
    inputReads
    main:
        trimreads(inputReads)
    emit:
        trimreads.out
}