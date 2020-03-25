#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2



/*rule UMItools:
    input:
        bam="results/mapped/{sample}.Aligned.sortedByCoord.out.bam",
    output:
        bam="results/dedup/{sample}.dedup.bam",
        stats="results/dedup/stats/{sample}_edit_distance.tsv"
    params:
        stats="results/dedup/stats/{sample}",
        cluster="-N 1 -c 1 --mem-per-cpu=32GB -J UMItools -t 6:00:00 -o logs/UMItools.{sample}.%A.log"
    shell:
        """
        umi_tools dedup --umi-separator=":" -I {input.bam} -S {output.bam} --output-stats={params.stats}
        """*/



// dedup reusable component
process dedup {
    input:
      tuple path(bam), path(bai)

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