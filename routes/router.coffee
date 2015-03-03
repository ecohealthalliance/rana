getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/form',
  where: 'client'
  onBeforeAction: ()->
    Session.set("reportDoc", null)
    @next()
  data: ->
    type: "insert"
)

Router.route('/form/:reportId',
  template: 'form'
  where: 'client'
  onBeforeAction: ()->
    Session.set("reportDoc", getCollections().Reports.findOne(@params.reportId))
    @next()
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
  data: ->
    currentReport = getCollections().Reports.findOne(@params.reportId)
    if Meteor.userId() and Meteor.userId() == currentReport.createdBy.userId
      type: "update"
    else
      type: "readonly"
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
