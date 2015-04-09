getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/report'
  template: 'reportForm'
  where: 'client'
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
