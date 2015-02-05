if Meteor.isServer
  Meteor.publish "userData", () ->
    if @userId
      Meteor.users.find()
      
if Meteor.isClient
  Meteor.subscribe "userData"