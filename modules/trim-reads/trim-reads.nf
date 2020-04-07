#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Trimming reusable component
process cutadapt {
    // Tag
    tag "${sample_id}"

    publishDir "${params.outdir}/${params.cutadapt_processname}",
        mode: "copy", overwrite: true

    input:
        //tuple val(sample_id), path(reads)
        path(reads)

    output:
        //tuple val(sample_id), path("${reads.simpleName}.trimmed.fq.gz")
        path("${reads.simpleName}.trimmed.fq.gz")

    shell:
    """
    cutadapt \
        -j 8 \
        -q 10 \
        --minimum-length 16 \
        -a AGATCGGAAGAGC \
        -o ${reads.simpleName}.trimmed.fq.gz $reads
    """
}