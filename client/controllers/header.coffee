Template.navLinks.events
  'click a' : (e) ->
    if($('.navbar-toggle').is(':visible'))
      $('.navbar-collapse').collapse('toggle')
    else

      $(".nav").find(".active").removeClass("active");
      $(e.target).parent().addClass("active");
  'click .sign-out'
    Meteor.logout()

Template.navLinks.helpers
  groupId: () ->
  	Groups.findOne({path: 'rana'})._id