#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Trimming reusable component
process trimreads {
    input:
        path reads

    output:
        path "${reads.baseName}.trimmed.fq.gz"

    shell:
    """
    cutadapt -j 8 --minimum-length 16 -q 10 -a AGATCGGAAGAGC -o ${reads.baseName}.trimmed.fq.gz $reads
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