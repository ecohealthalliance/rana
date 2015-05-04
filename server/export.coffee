sharedOrCreator = (userId) ->
  {
    $or : [
      {
        "createdBy.userId": userId
      }
      {
        dataUsePermissions: "Share full record",
        consent: true
      }
    ]
  }

Reports = () =>
  @collections.Reports

Studies = () =>
  @collections.Studies

reportSchema = () =>
  @reportSchema

Meteor.methods
  'export' : (query) ->
    reports = Reports().find(
      $and: [
        query
        sharedOrCreator(@userId)
      ]
    ).fetch()

    keys = ['studyName'].concat reportSchema()._schemaKeys
    keys = _.without keys, 'studyId', '_id', 'contact', 'eventLocation', 'createdBy', 'createdBy.userId', 'contact.institutionAddress', 'eventLocation.geo', 'pathologyReports', 'images'
    keys = _.filter keys, (key) ->
      not /\$/.test key
    
    csvRows = [keys.join(",")]

    for report in reports
      row = []
      for key in keys
        if key is 'studyName'
          output = Studies().findOne(report.studyId).name
        else
          output = report
          for key in key.split(".")
            if output and key of output
              output = output[key]
            else
              output = undefined
          if _.isArray output
            output = output.join(",")
        row.push "\"#{output}\""
      csvRows.push row.join(",")

    csvRows.join("\n")
