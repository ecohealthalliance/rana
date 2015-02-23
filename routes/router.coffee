Router.configure
  layoutTemplate: "layout"

Router.map () ->

  @route('form',
    path: '/'
    where: 'client'
  )

  @route('mapForm',
    path: '/map'
    where: 'client'
  )

  @route('info',
    path: '/info'
    where: 'client'
  )
