#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Trimming reusable component
process cutadapt {
    input:
        tuple val(sample_id), path(reads)

    output:
        tuple val(sample_id), path("${reads.simpleName}.trimmed.fq.gz")

    shell:
    """
    cutadapt -j 8 --minimum-length 16 -q 10 -a AGATCGGAAGAGC -o ${reads.simpleName}.trimmed.fq.gz $reads
    """
}