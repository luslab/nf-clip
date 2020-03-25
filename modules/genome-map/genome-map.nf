#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

/*
rule mapStarLenient5p:
    input:
        fastq="results/premapping/{sample}.tRNA_unmapped.fq.gz",
    output:
        bam="results/mapped/{sample}.Aligned.sortedByCoord.out.bam",
        bai="results/mapped/{sample}.Aligned.sortedByCoord.out.bam.bai",
        log="results/logs/{sample}.genome.log",
    params:
        STAR_GRCm38_GencodeM24=config['STAR_GRCm38_GencodeM24'],
        outprefix="results/mapped/{sample}.",
        log="results/mapped/{sample}.Log.final.out",
        cluster="-J mapStar -N 1 -c 8 --mem-per-cpu=4GB -t 6:00:00 -o logs/mapStar.{sample}.%A.log"
    threads:
        8
    shell:
        """
        STAR --runThreadN {threads} \
        --genomeDir {params.STAR_GRCm38_GencodeM24} --genomeLoad NoSharedMemory \
        --readFilesIn {input.fastq} --readFilesCommand zcat \
        --outFileNamePrefix {params.outprefix} \
        --outFilterMultimapNmax 1 --outFilterMultimapScoreRange 1 \
        --outSAMattributes All --alignSJoverhangMin 8 --alignSJDBoverhangMin 1 --outFilterType BySJout \
        --alignIntronMin 20 --alignIntronMax 1000000 --outFilterScoreMin 10 --alignEndsType Extend5pOfRead1 \
        --twopassMode Basic \
        --outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 60000000000
        sambamba index -t {threads} {output.bam}
        mv {params.log} {output.log}
        """
*/

//             --outFileNamePrefix ${reads%.unmapped.fq} \

//        sambamba index -t 2 {output.bam}
//        mv {params.log} {output.log}

// star reusable component
process star {
    input:
      path reads
      path star_index

    output:
      file "*.Aligned.sortedByCoord.out.{bam,log}"
//      file "*.Aligned.sortedByCoord.out.{bam,bam.bai,log}"
//      file "*.Aligned.sortedByCoord.out."
//      file "*.genome.log"

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
             --limitBAMsortRAM 600000000


    """
}

 workflow genomemap {
    take: inputReads
    take: starIndex
    main:
      star(inputReads, starIndex)
    emit:
      star.out
}