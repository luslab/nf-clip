#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2
// params.bowtie_index = ''

// fastqc reusable component
process bowtie_rrna {
    input:
        each reads
        path bowtie_index

    output:
        tuple path("${reads.simpleName}.bam"), path("${reads.simpleName}")
        
    script:
        """
        gunzip -c $reads | bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un ${reads.simpleName} ${bowtie_index}/small_rna_bowtie - | \
        samtools view -hu -F 4 - | \
        sambamba sort -t 8 -o ${reads.simpleName}.bam /dev/stdin
        """    

}