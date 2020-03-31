#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

process bowtie_rrna {
    input:
        each path(reads)
        path bowtie_index

    output:
        //tuple path("${reads.simpleName}.bam"), path("${reads.simpleName}.fq")
        path "${reads.simpleName}.bam", emit: rrnaBam
        path "${reads.simpleName}.fq", emit: unmappedFq

    script:
        """
        gunzip -c $reads | bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un ${reads.simpleName}.fq ${bowtie_index}/small_rna_bowtie - | \
        samtools view -hu -F 4 - | \
        sambamba sort -t 8 -o ${reads.simpleName}.bam /dev/stdin
        """
}