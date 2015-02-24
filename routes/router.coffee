getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/form',
  where: 'client'
  data: ->
    # This session variable is used as a mechanism for setting
    # the form's content in code.
    # Currently it is used in the tests to fill out forms.
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
  waitOn: ->
    [
      Meteor.subscribe("reports")
    ]
)

Router.route('/info',
  where: 'client'
)
