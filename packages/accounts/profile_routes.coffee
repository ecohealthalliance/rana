UserProfileSchema = share.UserProfileSchema

Router.route 'profile', 
  
  action: () ->
    @redirect "/profile/#{Meteor.userId()}"
    
Router.plugin "ensureSignedIn", {only: ["profile"]}


Router.route '/profile/:_id',
  
  template: 'profile'
  
  data: () ->
    
    user: Meteor.users.findOne @params._id
    isCurrentUser: Meteor.userId() is @params._id
    profileSchema: UserProfileSchema
    
  waitOn: () ->
    Meteor.subscribe "userInfo", @params._id

    