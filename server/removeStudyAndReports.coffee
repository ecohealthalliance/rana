Meteor.methods

  removeStudyAndReports: (studyId) =>
    study = collections.Studies.findOne(
      { '_id': studyId, 'createdBy.userId': Meteor.userId() }
    )
    if study
      collections.Studies.remove { '_id': studyId }
      collections.Reports.remove { 'studyId': studyId }
