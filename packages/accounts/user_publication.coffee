Meteor.publish "userInfo", (userId) ->
  Meteor.users.find {_id: userId}, {profile: 1, approval: 1}