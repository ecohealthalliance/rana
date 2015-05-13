Template.header.events
  'click a' : (e) ->
    $('.navbar-nav li, .navbar-brand').removeClass('active').blur()
    if $('.navbar-toggle').is(':visible') and !$(e.target).hasClass('dropdown-toggle')
      $('.navbar-collapse').collapse('toggle')
Template.navLinks.events
  'click .sign-out' : () ->
    Meteor.logout()

Template.navLinks.helpers
  groupId: () ->
  	Groups.findOne({path: 'rana'})?._id
  checkActive: (path) ->
    if path is Router.current().url
      'active'