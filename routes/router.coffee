getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('/form',
  where: 'client'
  onBeforeAction: ()->
    if Meteor.userId()
      @next()
    else
      @render('mustSignIn')
)

Router.route('/form/:reportId',
  template: 'form'
  where: 'client'
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
