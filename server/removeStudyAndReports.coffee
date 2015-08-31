Meteor.methods

  removeStudyAndReports: (studyId) =>
    study = collections.Studies.findOne(
      { '_id': studyId, 'createdBy.userId': Meteor.userId() }
    )
    unless study
      group = Groups.findOne({path: 'rana'})._id
      if Roles.userIsInRole Meteor.userId(), 'admin', group
        study = collections.Studies.findOne({'_id': studyId})

    if study
      collections.Studies.remove { '_id': studyId }
      collections.Reports.remove { 'studyId': studyId }
