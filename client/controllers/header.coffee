Template.header.events
  'click a, click button' : (e) ->
    console.log 'clicked'
    $(e.currentTarget).blur()
    $('.navbar-nav li').removeClass('active')
Template.navLinks.events
  'click a' : (e) ->
    if $('.navbar-toggle').is(':visible') and !$(e.currentTarget).hasClass('dropdown-toggle')
      $('.navbar-collapse').collapse('toggle')
    else 
      $(".nav").find(".active").removeClass("active")
      $(e.target).parent().toggleClass("active")

  'click .sign-out' : () ->
    Meteor.logout()

Template.navLinks.helpers
  groupId: () ->
  	Groups.findOne({path: 'rana'})?._id
