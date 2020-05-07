#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.crosslinks_processname = 'crosslinks'

process getcrosslinks {
    label 'mid_memory'
    publishDir "${params.outdir}/${params.crosslinks_processname}",
        mode: "copy", overwrite: true

    input:
      tuple val(sample_id), path(bam), path (fai)

    output:
      tuple val(sample_id), path ("${bam.simpleName}.xl.bed.gz"), emit: crosslinkBam

    script:
    """
    bedtools bamtobed -i $bam > dedupe.bed
    bedtools shift -m 1 -p -1 -i dedupe.bed -g $fai > shifted.bed
    bedtools genomecov -dz -strand + -5 -i shifted.bed -g $fai | awk '{OFS="\t"}{print \$1, \$2, \$2+1, ".", \$3, "+"}' > pos.bed
    bedtools genomecov -dz -strand - -5 -i shifted.bed -g $fai | awk '{OFS="\t"}{print \$1, \$2, \$2+1, ".", \$3, "-"}' > neg.bed
    cat pos.bed neg.bed | sort -k1,1 -k2,2n | pigz > ${bam.simpleName}.xl.bed.gz
    """
}