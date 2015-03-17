getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/report'
  template: 'reportForm'
  where: 'client'
)

Router.route('editReport',
  path: '/report/:reportId'
  template: 'reportForm'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
)

Router.route('importForm',
  path: '/import'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("csvfiles"),
      Meteor.subscribe("studies")
    ]
)

Router.route('/table',
  where: 'client'
  data: ->
    collection: collections.Reports
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

Router.plugin 'ensureSignedIn', {only: ['reportForm']}
