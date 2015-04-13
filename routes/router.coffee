getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/study/:studyId/report'
  template: 'reportForm'
  where: 'client',
  data: ->
    study: getCollections().Studies.findOne(@params.studyId)
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("reports"),
      Meteor.subscribe("studies")
    ]
)

Router.route('editReport',
  path: '/report/:reportId'
  template: 'reportForm'
  where: 'client'
  data: ->
    reportId: @params.reportId
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("reports"),
      Meteor.subscribe("studies")
    ]
)

Router.route('newStudy',
  path: '/study'
  template: 'studyForm'
  where: 'client'
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("csvfiles"),
      Meteor.subscribe("studies")
    ]
)

Router.route('editStudy',
  path: '/study/:studyId'
  template: 'study'
  where: 'client'
  data: ->
    study: getCollections().Studies.findOne(@params.studyId)
    reports: getCollections().Reports.find({studyId: @params.studyId})
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("studies"),
      Meteor.subscribe("reports"),
      Meteor.subscribe("csvfiles")
    ]
)

Router.route('/studies',
  where: 'client'
  data: ->
    studies: getCollections().Studies.find()
  waitOn: ->
    [
      Meteor.subscribe('studies')
    ]
)

Router.route('/table',
  where: 'client'
  data: ->
    collection: getCollections().Reports.find()
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
)

Router.route('/studyTable',
  where: 'client'
  data: ->
    collection: collections.Studies
  waitOn: ->
    [
      Meteor.subscribe("studies")
    ]
)

Router.route('/map',
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
)

Router.route('/info',
  where: 'client'
)

Router.plugin 'ensureSignedIn', {only: ['newReport', 'editReport', 'newStudy']}
