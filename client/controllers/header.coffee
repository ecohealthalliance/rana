Template.header.events
  'click .navbar-nav a' : (e) ->
    $('.navbar-nav li, .navbar-brand').removeClass('active').blur()
Template.navLinks.events
  'click .sign-out' : () ->
    Meteor.logout()

Template.navLinks.helpers
  groupId: () ->
  	Groups.findOne({path: 'rana'})?._id
  checkActive: (path) ->
    if path is Router.current().url
      'active'