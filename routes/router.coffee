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
  waitOn: ->
    [
      Meteor.subscribe("reports"),
      Meteor.subscribe("studies"),
      Meteor.subscribe("genera")
    ]
)

Router.route('editReport',
  path: '/report/:reportId'
  template: 'reportForm'
  where: 'client'
  data: ->
    reportId: @params.reportId
  waitOn: ->
    [
      Meteor.subscribe("reports"),
      Meteor.subscribe("studies"),
      Meteor.subscribe("genera")
    ]
)

Router.route('newStudy',
  path: '/study'
  template: 'studyForm'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("csvfiles"),
      Meteor.subscribe("studies"),
      Meteor.subscribe("genera")
    ]
)

Router.route('study',
  path: '/study/:studyId'
  template: 'study'
  where: 'client'
  data: ->
    study: getCollections().Studies.findOne(@params.studyId)
    reports: getCollections().Reports.find({studyId: @params.studyId})
  waitOn: ->
    [
      Meteor.subscribe("studies"),
      Meteor.subscribe("reports")
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
