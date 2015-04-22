Template.navLinks.events
  'click a' : (e) ->
    console.log e
    if($('.navbar-toggle').is(':visible'))
      $('.navbar-collapse').collapse('toggle')
    else

      $(".nav").find(".active").removeClass("active");
      $(e.target).parent().addClass("active");