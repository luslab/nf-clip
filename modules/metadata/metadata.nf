workflow metadata {
    take: params.input
    main:
        Channel
            .fromPath( params.input )
            .splitCsv(header:true)
            .map { row -> file(row.fastq) }
            // .map { row -> [ row.sample_id, [ file(row.fastq, checkIfExists: true) ] ] }
            .set { ch_testData }
    emit:
        ch_testData
}