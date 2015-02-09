Groups = @Groups
Invites = @Invites

Router.route "/group/:groupPath", () ->
  group = Groups.findOne {path: @params.groupPath}
  @render "groupHome", {
    data: () ->
      group: group
      groups: Groups
      groupAdmins: Roles.getUsersInRole "admin", group?._id
      groupUsers: Roles.getUsersInRole "user", group?._id
  }
    

Router.route "/newGroup", () ->
  @render "newGroup", {
    data: () ->
      groups: Groups
  }

Router.route "/join/:inviteId", () ->
  invite = Invites.findOne(@params.inviteId)
  @render "join", {
    data: () ->
      invite: invite
      group: Groups.findOne(invite?.group)    
  }