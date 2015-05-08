reportHook = (userId, doc)=>
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
@collections.Reports.after.insert reportHook
@collections.Reports.after.update reportHook

studyHook = (userId, doc)=>
  @collections.PDFs.update({
    _id: doc?.publicationInfo?.pdf
    studyId: { $exists: false }
  }, {
    $set:
      studyId: doc._id
  })
  @collections.CSVFiles.update({
    _id: doc?.csvFile
    owner: { $exists: false }
  }, {
    $set:
      owner: userId
  })
@collections.Studies.after.insert studyHook
@collections.Studies.after.update studyHook
