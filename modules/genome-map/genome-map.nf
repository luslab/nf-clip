#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// star reusable component
process star {
    label 'mid_memory'
    input:
      each path(reads)
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
    label 'mid_memory'
    input:
      path bam

    output:
      path "*.bam.bai", emit: baiFiles
    
    script:
    """
    sambamba index -t 2 $bam
    """
}

process rename_files {
    label 'low_memory'
    input:
      path baiFile
      path logFile

    output:
      path "*.bai", emit: renamedBaiFiles
      path "*.genome.log", emit: renamedLogFiles
    
    script:
    """
    logFileName=`basename $logFile`
    logBaseName="\${logFileName%.Log.final.out}"
    mv $logFile \${logBaseName}.genome.log
    baiFileName=`basename $baiFile`
    baiBaseName="\${baiFileName%.bam.bai}"
    mv $baiFile \${baiBaseName}.bai
    """
}

process collect_outputs {
    label 'low_memory'
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
      rename_files(sambamba.out.baiFiles, star.out.logFiles)
      collect_outputs(star.out.bamFiles, rename_files.out.renamedBaiFiles, rename_files.out.renamedLogFiles)
    emit:
      collect_outputs.out
}