if Meteor.isServer
  Meteor.publish "userData", () ->
    if @userId
      Meteor.users.find {}, {fields: {emails: 1, roles: 1}}
