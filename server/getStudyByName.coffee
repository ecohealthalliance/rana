Meteor.methods

  getStudyByName: (studyName) ->
    collections.Studies.findOne
      name: studyName
      $or : [
        {
          "createdBy.userId": @userId
        }
        {
          dataUsePermissions: "Share full record",
          consent: true
        }
      ]
