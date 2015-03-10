getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/form',
  where: 'client'
)

Router.route('/form/:reportId',
  template: 'form'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("reports")
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

Router.plugin 'ensureSignedIn', {only: ['form']}
