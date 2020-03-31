#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

params.outdir = './results'

// Trimming reusable component
process cutadapt {
    publishDir "${params.outdir}/cutadapt",
        mode: "copy", overwrite: true

    input:
        //tuple val(sample_id), path(reads)
        path(reads)

    output:
        //tuple val(sample_id), path("${reads.simpleName}.trimmed.fq.gz")
        path("${reads.simpleName}.trimmed.fq.gz")

    shell:
    """
    cutadapt -j 8 --minimum-length 16 -q 10 -a AGATCGGAAGAGC -o ${reads.simpleName}.trimmed.fq.gz $reads
    """
}