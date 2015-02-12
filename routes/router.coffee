getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/form'))

Router.route('/form',
  where: 'client'
  data: ->
    reportDoc: Session.get("reportDoc")
)

Router.route('/form/:reportId',
  template: 'form'
  where: 'client'
  data: ->
    Session.set("reportDoc", getCollections().Reports.findOne(@params.reportId))
    return {
      reportDoc: Session.get("reportDoc")
    }
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
  #waitOn: ->
    #[
      #Meteor.subscribe("reports")
    #]
)

Router.route('/info',
  where: 'client'
)
