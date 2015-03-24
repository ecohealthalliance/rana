getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/report'
  template: 'reportForm'
  where: 'client',
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

Router.route('/table',
  where: 'client'
  data: ->
    collection: collections.Reports
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
