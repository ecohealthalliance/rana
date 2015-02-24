Meteor.publish 'files', ->
  collections.Files.find()

@collections.Files.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'reports', ->
  collections.Reports.find({
    $or : [
      # The other option will be for the report to belong to the current user
      # once we've linked accounts to reports.
      {
        dataUsePermissions: "Share full record",
        consent: true
      }
    ]
  })

@collections.Reports.allow
  insert: -> true
  update: -> true
  remove: -> true
