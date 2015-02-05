Router.configure
  layoutTemplate: "layout"

Router.map () ->

  @route('form',
    path: '/'
    where: 'client'
  )

  @route('map',
    path: '/map'
    where: 'client'
    #waitOn: ->
      #[
        #Meteor.subscribe("reports")
      #]
  )

  @route('info',
    path: '/info'
    where: 'client'
  )
