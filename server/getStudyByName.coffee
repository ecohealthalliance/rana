Meteor.methods

  getStudyByName: (studyName) =>
    collections.Studies.findOne(
      { 'name': studyName }
    )
