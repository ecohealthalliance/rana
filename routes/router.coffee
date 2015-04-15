getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/study/:studyId/report'
  template: 'reportForm'
  where: 'client',
  data: ->
    study: getCollections().Studies.findOne @params.studyId
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
    report: getCollections().Reports.findOne @params.reportId
  onAfterAction: ->
    Meteor.subscribe("genera")
    Meteor.subscribe("reviews", @params.reportId)
  waitOn: ->
    [
      Meteor.subscribe("reports")
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
      Meteor.subscribe("csvfiles"),
      Meteor.subscribe("groupByPath", "rana")
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
  waitOn: ->
    [
      Meteor.subscribe("reports")
      Meteor.subscribe("groupByPath", "rana")
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
