window.utils =
  # Based on bobince's regex escape function.
  # source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
  regexEscape: (s)->
    s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
  # In IE's native toLocaleDateString there can be invisable whitespace in
  # the output. This implementation removes the invisable whitespace.
  toLocaleDateString: (d)->
    d.toLocaleDateString().replace(new RegExp(String.fromCharCode(8206), "g"), "")
Template.registerHelper 'isRanaAdmin', () ->
  Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id
