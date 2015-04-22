@collections.Files.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  download: (userId)->
    true

@collections.CSVFiles.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  download: (userId)->
    true

# This makes it so it isn't possible to retrieve all the records in the system.
# It is necessairy to know their id, which should make it necessairy to have
# access to the record they are attached to.
onlyById = (collection)->
  (id)->
    if _.isArray id
      ids = id
    else
      ids = [id]
    # It doesn't seem to be possible to pass in RegExps
    # but we still check for them just incase it becomes possible in
    # future versions of Meteor.
    if ids.some(_.isRegExp)
      return null

    collection.find({_id: {$in: ids}})

Meteor.publish 'files', onlyById(collections.Files)

Meteor.publish 'genera', ->
  collections.Genera.find()

Meteor.publish 'pdfs', onlyById(collections.PDFs)

@collections.PDFs.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'csvfiles', onlyById(collections.CSVFiles)

Meteor.publish 'studies', ->
  collections.Studies.find()

Meteor.publish 'reports', ->
  # Uncomment this if the admin should be allowed to see unpublished reports.
  #if Roles.userIsInRole @userId, 'admin', Groups.findOne({path:"rana"})._id
    #return collections.Reports.find({})
  collections.Reports.find({
    $or : [
      {
        "createdBy.userId": @userId
      }
      {
        dataUsePermissions: "Share full record",
        consent: true
      }
    ]
  })

Meteor.publish 'reviews', (reportId)->
  collections.Reviews.find({reportId : reportId})

allowCreatorAndAdmin = (userId, doc) ->
  if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
    return true
  else
    return doc.createdBy.userId == userId

@collections.Reports.allow
  insert: allowCreatorAndAdmin
  update: allowCreatorAndAdmin
  remove: allowCreatorAndAdmin

@collections.Studies.allow
  insert: allowCreatorAndAdmin
  update: allowCreatorAndAdmin
  remove: allowCreatorAndAdmin

@collections.Reviews.allow
  insert: allowCreatorAndAdmin
  update: allowCreatorAndAdmin
  remove: allowCreatorAndAdmin
