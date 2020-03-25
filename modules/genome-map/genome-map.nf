#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// star reusable component
process star {
    input:
      each reads
      path star_index

    output:
      path "*.Aligned.sortedByCoord.out.bam", emit: bamFiles
      path "*.Log.final.out", emit: logFiles

    script:
    """
        fileName=`basename $reads`
        prefix="\${fileName%.fq}."
        STAR --runThreadN 2 \
             --genomeDir $star_index \
             --genomeLoad NoSharedMemory \
             --readFilesIn $reads \
             --outFileNamePrefix \$prefix \
             --outFilterMultimapNmax 1 \
             --outFilterMultimapScoreRange 1 \
             --outSAMattributes All \
             --alignSJoverhangMin 8 \
             --alignSJDBoverhangMin 1 \
             --outFilterType BySJout \
             --alignIntronMin 20 \
             --alignIntronMax 1000000 \
             --outFilterScoreMin 10  \
             --alignEndsType Extend5pOfRead1 \
             --twopassMode Basic \
             --outSAMtype BAM SortedByCoordinate \
             --limitBAMsortRAM 6000000000
    """
}

process sambamba {
    input:
      path bam

    output:
      path "*.bam.bai"
    
    script:
    """
        sambamba index -t 2 $bam
    """
}

process rename_log {
    input:
      path logFile

    output:
      path "*.genome.log"
    
    script:
    """
        fileName=`basename $logFile`
        sampleName="\${fileName%.Log.final.out}"
        mv $logFile \${sampleName}.genome.log
    """
}

process collect_outputs {
    input:
      path bamFile
      path baiFile
      path logFile

    output:
      tuple path(bamFile), path(baiFile), path(logFile)

    script:
    """
    """
}

 workflow genomemap {
    take: inputReads
    take: starIndex
    main:
      star(inputReads, starIndex)
      sambamba(star.out.bamFiles)
      rename_log(star.out.logFiles)
      collect_outputs(star.out.bamFiles, sambamba.out, rename_log.out)
    emit:
      collect_outputs.out
}