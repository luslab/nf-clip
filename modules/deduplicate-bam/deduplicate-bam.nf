#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.dedup_processname = 'dedup'

// dedup reusable component
process dedup {
    publishDir "${params.outdir}/${params.dedup_processname}",
        mode: "copy", overwrite: true

    input:
      tuple val(pairId), path(bai), path(bam)

    output:
      tuple path("*.dedup.bam"), path("*_edit_distance.tsv")

    script:
    """
        fileName=`basename $bam`
        sampleName="\${fileName%.Aligned.sortedByCoord.out.bam}"
        umi_tools dedup --umi-separator=":" -I $bam -S \${sampleName}.dedup.bam --output-stats=\${sampleName}
    """
}
