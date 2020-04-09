#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.dedup_processname = 'dedup'


//Process to get a key pair ID
process generatekey {

  input:
    path(bam)

  output:
    val pairId

  script:
    pairId = bam.simpleName   
}

// dedup reusable component
process dedup {
    publishDir "${params.outdir}/${params.dedup_processname}",
        mode: "copy", overwrite: true

    input:
      tuple val(pairId), path(bai), path(bam) from 
       
    output:
      tuple path("*.dedup.bam"), path("*_edit_distance.tsv")

    script:
    """
        fileName=`basename $bam`
        sampleName="\${fileName%.Aligned.sortedByCoord.out.bam}"
        umi_tools dedup --umi-separator=":" -I $bam -S \${sampleName}.dedup.bam --output-stats=\${sampleName}
    """
}
