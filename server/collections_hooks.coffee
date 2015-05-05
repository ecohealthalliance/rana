@collections.Reports.after.insert (userId, doc)=>
  ids = _.pluck(doc.pathologyReports, "report").concat(
    _.pluck(doc.images, "image")
  )
  ids.forEach (id)->
    @collections.Files.update({
      _id: id
      reportId: { $exists: false }
    }, {
      $set:
        reportId: doc._id
    })

@collections.Studies.after.insert (userId, doc)=>
  @collections.PDFs.update({
    _id: doc?.publicationInfo?.pdf
    studyId: { $exists: false }
  }, {
    $set:
      studyId: doc._id
  })
  @collections.CSVFiles.update({
    _id: doc?.csvFile
    studyId: { $exists: false }
  }, {
    $set:
      studyId: doc._id
  })
