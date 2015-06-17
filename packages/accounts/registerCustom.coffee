Template.registerCustom.rendered = () ->
  Tracker.autorun () ->
    error = AccountsTemplates.state.form.get('error')
    if error?.length
      $("body").animate({ scrollTop: 0 }, 100)
