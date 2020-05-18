workflow metadata {
    take: csv
    main:
        Channel
            .fromPath( csv )
            .splitCsv(header:true)
            .map { row -> [ row.sample_id, file(row.fastq, checkIfExists: true) ]  }
            .set { data }
    emit:
        data
}