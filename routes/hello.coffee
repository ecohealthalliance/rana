Router.configure
  layoutTemplate: "layout"

Router.map () ->

  @route('hello',
    path: '/'
    where: 'client'
  )
