Meteor.publish "userInfo", (userId) ->
  if Roles.userIsInRole @userId, 'admin', Groups.findOne({path:"rana"})._id
    Meteor.users.find {}, {profile: 1, approval: 1}
  else
    if userId
      Meteor.users.find {_id: userId}, {profile: 1, approval: 1}
    else
      @ready()
