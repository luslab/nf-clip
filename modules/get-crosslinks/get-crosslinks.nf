#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process getcrosslinks {
    input:
      each bam
      path fai

    output:
      // file "*.bed.gz"
      path "${bam.baseName}.xl.bed.gz"

    script:
    """
    bedtools bamtobed -i $bam > dedupe.bed
    bedtools shift -m 1 -p -1 -i dedupe.bed -g $fai > shifted.bed
    bedtools genomecov -dz -strand + -5 -i shifted.bed -g $fai | awk '{OFS="\t"}{print \$1, \$2, \$2+1, ".", \$3, "+"}' > pos.bed
    bedtools genomecov -dz -strand - -5 -i shifted.bed -g $fai | awk '{OFS="\t"}{print \$1, \$2, \$2+1, ".", \$3, "-"}' > neg.bed
    cat pos.bed neg.bed | sort -k1,1 -k2,2n | pigz > ${bam.baseName}.xl.bed.gz
    """
}

 workflow get_crosslinks {
    take: inputBam
    main:
      getcrosslinks(inputBam)
    emit:
      crosslinks.out
}