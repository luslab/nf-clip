#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2
// params.bowtie_index = ''

// fastqc reusable component
process bowtie_rrna {
    input:
        each reads
        path bowtie_index

    output:
         tuple path("${reads.baseName}.bam"), path("${reads.baseName}.fq")
        //  file 'unmapped_reads_*'
        //  file '*_mapped.sam'

    script:
    """
    gunzip -c $reads | bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un ${reads.baseName} $bowtie_index  - | \
    samtools view -hu -F 4 - | \
    sambamba sort -t 8 -o ${reads.baseName}.bam /dev/stdin

        gunzip -c {input.fastq} | \
        bowtie -v 2 -m 1 --best --strata --threads 8 -q --sam --norc --un {output.unmapped_reads} {params.bowtie_index} - {output.sam} 2> {output.log}
        samtools view -hu -F 4 {output.sam} | sambamba sort -t 8 -o {output.bam} /dev/stdin
    """    
}

//  workflow premap {
//     take: reads
//     main:
//       bowtie_rrna(reads)
//     // emit:
//     //   bowtie_rrna.out
// }
