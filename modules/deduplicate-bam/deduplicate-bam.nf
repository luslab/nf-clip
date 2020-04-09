#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.dedup_processname = 'dedup'

//merging channels
process merge_pairId_bam {
  input:
    path(bam)
    path(bai)
    val pairId

  output:
    tuple val(pairId), path(bam), emit: bamPair
    tuple val(pairId), path(bai), emit: baiPair

  script:
  """
  """
}
// dedup reusable component
process dedup {
    publishDir "${params.outdir}/${params.dedup_processname}",
        mode: "copy", overwrite: true

    input:
      tuple val(pairId), path(bam), path(bai)  
       
    output:
      path "*.dedup.bam", emit: dedupBam
      path "*_edit_distance.tsv", emit: editDist

    script:
    """
        fileName=`basename $bam`
        sampleName="\${fileName%.Aligned.sortedByCoord.out.bam}"
        umi_tools dedup --umi-separator=":" -I $bam -S \${sampleName}.dedup.bam --output-stats=\${sampleName}
    """
}
