Template.help.helpers
  addActive: (navTitle, vidTitle) ->
    if navTitle is vidTitle
      'active'

  link : () ->
    topic: @title.replace RegExp(' ', 'g'), '-'