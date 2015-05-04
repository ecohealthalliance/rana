Template.navLinks.events
  'click a' : (e) ->
    if $('.navbar-toggle').is(':visible')
      $('.navbar-collapse').collapse('toggle')
    $(".nav").find(".active").removeClass("active")
    $(e.target).parent().addClass("active")
