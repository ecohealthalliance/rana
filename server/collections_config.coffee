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

Meteor.publish 'genera', ->
  collections.Genera.find()

@collections.PDFs.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc) ->
    true
  download: (userId)->
    true

sharedOrCreator = (userId) ->
  {
    $or : [
      {
        "createdBy.userId": userId
      }
      {
        dataUsePermissions: "Share full record"
        consent: true
      }
    ]
  }

Meteor.publishComposite 'studies', (id) ->
  find: () ->
    collections.Studies.find {
      $and: [
        { _id: id }
        sharedOrCreator @userId
      ]
    }
  children: [
    {
      find: (study) ->
        collections.PDFs.find
          _id: study?.publicationInfo?.pdf
          studyId: study._id
    }
  ]

ReactiveTable.publish "studies", collections.Studies,
  {
    $or : [
      {
        "createdBy.userId": @userId
      },
      {
        dataUsePermissions: { $in: [ "Share full record", "Share obfuscated" ] },
        consent: true
      }
    ]
  },
  { fields: { name: 1, createdBy: 1, dataUsePermissions: 1}}


Meteor.publish 'obfuscatedStudies', (id) ->
  collections.Studies.find(
    {
      _id: id,
      'dataUsePermissions': "Share obfuscated",
      'consent': true
    },
    { fields: {name: 1, dataUsePermissions: 1, createdBy: 1} }
  )

ReactiveTable.publish 'reports', collections.Reports, () ->
  sharedOrCreator @userId

ReactiveTable.publish 'obfuscatedReports', collections.Reports, (() ->
  {
    'dataUsePermissions': "Share obfuscated",
    'createdBy.userId': { $ne: @userId },
    'consent': true
  }),
  { fields: {'studyId': 1, 'dataUsePermissions': 1, 'createdBy.name': 1, 'eventLocation.country': 1} }

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

  report = collections.Reports.findOne(reportId)

  find: () ->
    collections.Reports.find(
      {
        $and: [
          {
            _id: reportId
          }
          sharedOrCreator @userId
        ]
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
    {
      find: (report) ->
        ids = _.pluck(report?.images or [], "image")
        if ids.some(_.isRegExp)
          return []
        collections.Files.find
          _id:
            $in: ids
          reportId: report._id
    }
    {
      find: (report) ->
        ids = _.pluck(report?.pathologyReports or [], "report")
        if ids.some(_.isRegExp)
          return []
        collections.Files.find
          _id:
            $in: ids
          reportId: report._id
    }
    {
      find: (report) ->
        collections.Reviews.find {reportId : report._id}
    }
  ]

Meteor.publishComposite 'obfuscatedReportAndStudy', (reportId) ->

  report = collections.Reports.findOne(reportId)

  find: () ->
    collections.Reports.find(
      {
        _id: reportId
        dataUsePermissions: 'Share obfuscated'
      }
      {
        fields: {
          studyId: true
          dataUsePermissions: true
          createdBy: true
          contact: true
          'eventLocation.country': true
        }
      }
    )
  children: [
    {
      find: (report) ->
        collections.Studies.find {
          _id: report.studyId
        }, {fields: {name: 1}}
    }
  ]

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
