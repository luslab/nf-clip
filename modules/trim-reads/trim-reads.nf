#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Cutadapt reusable component
process cutadapt {
    input:
        path reads

    output:
        file "trimmed_reads*"

    shell:
    """
    cutadapt --quiet --threads 
    """
}

workflow trimreads {
    take: 
    inputReads
    main:
        cutadapt(inputReads)
    emit:
        trimreads.out
}