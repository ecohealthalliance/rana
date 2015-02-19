Meteor.publish "usersInGroup", (group) ->
  if Roles.userIsInRole @userId, 'admin', group
    # https://waffle.io/ecohealthalliance/rana/cards/54dbc58335ed7b03007bb89e
    Meteor.users.find {}, {fields: {emails: 1, roles: 1, profile: 1}}
  else
    @ready()
