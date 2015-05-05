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

Meteor.publish 'studies', (id) ->
  collections.Studies.find {
    $and: [
      { _id: id }
      sharedOrCreator @userId
    ]
  }

ReactiveTable.publish "studies", collections.Studies, () ->
  sharedOrCreator @userId

ReactiveTable.publish 'reports', collections.Reports, () ->
  sharedOrCreator @userId

Meteor.publishComposite "reportLocations", () ->
  find: () ->
    collections.Reports.find(
      {
        $and: [
          {
            "eventLocation.source": {"$exists": true}
          }
          sharedOrCreator @userId
        ]
      }
      {
        fields:
          studyId: 1
          eventLocation: 1
          speciesName: 1
          speciesGenus: 1
          populationType: 1
          vertebrateClasses: 1
          ageClasses: 1
          "createdBy.name": 1
          eventDate: 1
          totalAnimalsConfirmedInfected: 1
          totalAnimalsConfirmedDiseased: 1
      }
    )
  children: [
    {
      find: (report) ->
        collections.Studies.find {
          $and: [
            {_id: report.studyId}
            sharedOrCreator @userId
          ]
        }, {fields: {name: 1}}
    }
  ]

Meteor.publishComposite 'reportAndStudy', (reportId) ->
  find: () ->
    collections.Reports.find
      $and: [
        {
          _id: reportId
        }
        sharedOrCreator @userId
      ]
  children: [
    {
      find: (report) ->
        collections.Studies.find {
          $and: [
            {_id: report.studyId}
            sharedOrCreator @userId
          ]
        }, {fields: {name: 1}}
    }
  ]

Meteor.publish 'reviews', (reportId)->
  collections.Reviews.find({reportId : reportId})

allowCreator = (userId, doc) ->
  doc.createdBy.userId == userId

allowCreatorAndAdmin = (userId, doc) ->
  if Roles.userIsInRole userId, 'admin', Groups.findOne({path:"rana"})._id
    return true
  else
    allowCreator userId, doc

@collections.Reports.allow
  insert: allowCreator
  update: allowCreator
  remove: allowCreatorAndAdmin

@collections.Studies.allow
  insert: allowCreator
  update: allowCreator
  remove: allowCreatorAndAdmin

@collections.Reviews.allow
  insert: allowCreator
  update: allowCreator
  remove: allowCreatorAndAdmin
