#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Cutadapt reusable component
process cutadapt {
    input:
        path reads

    output:
        file "*_fastqc.{zip,html}"

    shell:
    """
    
    """
}

workflow trimreads {
    take: 
    inputReads
    main:
        cutadapt(reads)
    emit:
        cutadapt.out
}