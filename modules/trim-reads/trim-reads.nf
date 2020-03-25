#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Trimming reusable component
process cutadapt {
    input:
        path reads

    output:
        path "${reads.baseName}.trimmed.fq.gz"

    shell:
    """
    cutadapt -j 8 --minimum-length 16 -q 10 -a AGATCGGAAGAGC -o ${reads.baseName}.trimmed.fq.gz $reads
    """
}