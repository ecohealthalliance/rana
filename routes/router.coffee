getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/reportForm',
  path: '/report'
  where: 'client'
)

Router.route('/importForm',
  path: 'import'
  where: 'client'
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
