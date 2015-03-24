@collections.Files.allow
  insert: (userId, doc) ->
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

Meteor.publish 'files', ->
  collections.Files.find()

Meteor.publish 'genera', ->
  collections.Genera.find()

Meteor.publish 'pdfs', ->
  collections.PDFs.find()

@collections.PDFs.allow
  insert: (userId, doc) ->
    true
  download: (userId)->
    true

Meteor.publish 'csvfiles', ->
  collections.CSVFiles.find()

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

@collections.Reports.allow
  insert: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId
  update: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId
  remove: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId

@collections.Studies.allow
  insert: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId
  update: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId
  remove: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
      return true
    else
      return doc.createdBy.userId == userId