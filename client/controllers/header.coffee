Template.header.events
  'click a' : (e) ->
    $('.navbar-nav li, .navbar-brand').removeClass('active').blur()
    if $('.navbar-toggle').is(':visible') and $('.navbar-collapse').hasClass('in') and !$(e.currentTarget).hasClass('dropdown-toggle')
      $('.navbar-collapse').collapse('toggle')
  'click button' : (e) ->
    if $('.navbar-collapse').hasClass('in')
      $(e.target).blur()
Template.navLinks.events
  'click .sign-out' : () ->
    Meteor.logout()

Template.navLinks.helpers
  groupId: () ->
  	Groups.findOne({path: 'rana'})?._id
  groupPath: () ->
    groupPath: 'rana'
  checkActive: (routeName) ->
    if Router.path(routeName, {groupPath: 'rana'}) is Router.current().location.get().path
      'active'
