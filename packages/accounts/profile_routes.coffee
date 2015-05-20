UserProfileSchema = share.UserProfileSchema

BASE_PATH = '/grrs'

Router.route BASE_PATH + '/profile', 
  name: 'currentUserProfile'
  action: () ->
    @redirect Router.path 'profile', {_id: Meteor.userId()}
    
Router.plugin "ensureSignedIn", {only: ["profile"]}


Router.route BASE_PATH + '/profile/:_id',
  name: 'profile'
  template: 'profile'
  
  data: () ->
    
    user: Meteor.users.findOne @params._id
    isCurrentUser: Meteor.userId() is @params._id
    profileSchema: UserProfileSchema
    
  waitOn: () ->
    Meteor.subscribe "userInfo", @params._id

    