Template.help.helpers
  addActive: (navTitle, vidTitle) ->
    if navTitle is vidTitle
      'active'

  link : (title) ->
    title.replace RegExp(' ', 'g'), '-'