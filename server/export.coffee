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

    schema = reportSchema()._schema
    objectKeys = reportSchema()._objectKeys

    keys = ['studyName'].concat reportSchema()._schemaKeys
    keys = _.without keys, 'studyId', '_id', 'createdBy', 'createdBy.userId', 'eventLocation.geo.type', 'eventLocation.geo.coordinates'
    keys = _.filter keys, (key) ->
      hasUploadChildren = (key) ->

        if key + '.$.' of objectKeys
          for child in objectKeys[key + '.$.']
            childKey = key + '.$.' + child
            if schema[childKey].autoform?.afFieldInput?.type is 'fileUpload'
              return true
          false

      (not /\$/.test key) and not (key + '.' of objectKeys) and not (hasUploadChildren key)

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
