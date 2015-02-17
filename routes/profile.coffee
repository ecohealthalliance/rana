UserProfileSchema = @UserProfileSchema

Router.route 'profile/:_id', {
  template: 'profile'
  
  data: () ->
    user: Meteor.users.findOne @params._id
    isCurrentUser: Meteor.userId() is @params._id
    profileSchema: UserProfileSchema

}