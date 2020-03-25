#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process getcrosslinks {
    input:
      path reads

    output:
      file "*.bed.gz"

    script:
    """
    bedtools bamtobed -i {input.bam} > {output.dedupbed}
    bedtools shift -m 1 -p -1 -i {output.dedupbed} -g {params.fai} > {output.shiftedbed}
    bedtools genomecov -dz -strand + -5 -i {output.shiftedbed} -g {params.fai} | awk '{OFS="\t"}{print $1, $2, $2+1, ".", $3, "+"}' > {output.posbed}
    bedtools genomecov -dz -strand - -5 -i {output.shiftedbed} -g {params.fai} | awk '{OFS="\t"}{print $1, $2, $2+1, ".", $3, "-"}' > {output.negbed}
    cat {output.posbed} {output.negbed} | sort -k1,1 -k2,2n | pigz > {output.bed}
    """
}

 workflow getcrosslinks {
    take: inputBam
    main:
      getcrosslinks(inputBam)
    emit:
      crosslinks.out
}


rule getXlinks:
    input:
        bam="results/dedup/{sample}.dedup.bam",
    output:
        dedupbed=temp("results/xlinks/{sample}.dedup.bed"),
        shiftedbed=temp("results/xlinks/{sample}.shifted.bed"),
        posbed=temp("results/xlinks/{sample}.pos.bed"),
        negbed=temp("results/xlinks/{sample}.neg.bed"),
        bed="results/xlinks/{sample}.xl.bed.gz",
    params:
        fai=config['fai'],
        cluster="-N 1 -c 1 --mem-per-cpu=16GB -J getXlinks -t 6:00:00 -o logs/getXlinks.{sample}.%A.log"
    shell:
        """
        bedtools bamtobed -i {input.bam} > {output.dedupbed}
        bedtools shift -m 1 -p -1 -i {output.dedupbed} -g {params.fai} > {output.shiftedbed}
        bedtools genomecov -dz -strand + -5 -i {output.shiftedbed} -g {params.fai} | awk '{{OFS="\t"}}{{print $1, $2, $2+1, ".", $3, "+"}}' > {output.posbed}
        bedtools genomecov -dz -strand - -5 -i {output.shiftedbed} -g {params.fai} | awk '{{OFS="\t"}}{{print $1, $2, $2+1, ".", $3, "-"}}' > {output.negbed}
        cat {output.posbed} {output.negbed} | sort -k1,1 -k2,2n | pigz > {output.bed}
        """