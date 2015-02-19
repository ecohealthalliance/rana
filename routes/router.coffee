getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/form',
  where: 'client'
  onBeforeAction: ()->
    Session.set("reportDoc", null)
    @next()
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
  data: ->
    getCollections().Reports.find({
      eventLocation: { $ne : null },
      dataUsePermissions: "Share full record",
      consent: true
    })
    .map((report)-> {
      location: report.eventLocation.split(',').map(parseFloat)
      popupHTML: """<a href="">#{report.name}</a>"""
    })
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
)

Router.route('/info',
  where: 'client'
)
