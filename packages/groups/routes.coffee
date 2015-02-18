Groups = @Groups
Invites = @Invites

Router.route "/group/:groupPath", {
  
  template: 'groupHome'
  
  data: () ->
    group = Groups.findOne {path: @params.groupPath}
    
    group: group
    groups: Groups
    groupAdmins: Roles.getUsersInRole "admin", group?._id
    groupUsers: Roles.getUsersInRole "user", group?._id

  waitOn: () ->
    Meteor.subscribe "userData"
}
    

Router.route "/newGroup", {
  data: () ->
    groups: Groups
}

Router.route "/join/:inviteId", {
  template: 'join'
  
  data: () ->
    invite = Invites.findOne(@params.inviteId)
      
    invite: invite
    group: Groups.findOne(invite?.group)    
}