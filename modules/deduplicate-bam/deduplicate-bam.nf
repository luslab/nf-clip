#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// dedup reusable component
process dedup {
    input:
      tuple val(pairId), path(bai), path(bam)

    output:
      tuple path("*.dedup.bam"), path("*_edit_distance.tsv")

    script:
    """
        fileName=`basename $bam`
        sampleName="\${fileName%.Aligned.sortedByCoord.out.bam}"
        umi_tools dedup --umi-separator=":" -I $bam -S \${sampleName}.dedup.bam --output-stats=\${sampleName}
      # cp \${sampleName}/*_edit_distance.tsv .
    """
}

 workflow bamdedup {
    take: inputBamsBais
    main:
      dedup(inputBamsBais)
    emit:
      dedup.out
}