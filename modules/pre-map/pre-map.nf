#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// fastqc reusable component
process pre-map {
    input:
        path reads

    output:
        file "${unmapped_reads}"
        file "${bowtie_index}"
        file "${sam}"




        
      file "*_fastqc.{zip,html}"

    script:
    """
    gunzip -c $reads | \
    bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un $unmapped_reads $bowtie_index - $sam 2> {output.log}
    samtools view -hu -F 4 $sam | sambamba sort -t 8 -o $bam
    """
}


        output:
        sam=temp("results/premapping/{sample}.Aligned.out.sam"),
        log="results/logs/{sample}.bowtie.smallrna.log",
        unmapped_reads="results/premapping/{sample}.Unmapped.fq",
        bam="results/premapping/{sample}.Aligned.out.sorted.bam",
        bai="results/premapping/{sample}.Aligned.out.sorted.bam.bai"

params.unmapped_reads = 'modules/pre-map/output/unmapped_reads.fq'


 workflow pre-map {
    take: inputReads
    main:
      pre-map(inputReads)
    emit:
      pre-map.out
}



# =============================================================================
# Pre-mapping
# =============================================================================

rule bowtieMapsmRNA:
    input:
        fastq="results/trimmed/{sample}.fq.gz"
    output:
        sam=temp("results/premapping/{sample}.Aligned.out.sam"),
        log="results/logs/{sample}.bowtie.smallrna.log",
        unmapped_reads="results/premapping/{sample}.Unmapped.fq",
        bam="results/premapping/{sample}.Aligned.out.sorted.bam",
        bai="results/premapping/{sample}.Aligned.out.sorted.bam.bai"
    params:
        bowtie_index=config['rRNA_tRNA_index'],
        cluster="-N 1 -c 8 -J bt_map_rRNA_tRNA --mem=32G -t 1:00:00"
    threads:
        8
    shell:
        """
        gunzip -c {input.fastq} | \
        bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un {output.unmapped_reads} {params.bowtie_index} - {output.sam} 2> {output.log}
        samtools view -hu -F 4 {output.sam} | sambamba sort -t 8 -o {output.bam} /dev/stdin
        """
