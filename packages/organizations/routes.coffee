Orgs = @Orgs
Invites = @Invites

Router.route "/org/:orgPath", () ->
  org = Orgs.findOne {path: @params.orgPath}
  @render "orgHome", {
    data: () ->
      org: org
      orgs: Orgs
      orgAdmins: Roles.getUsersInRole "admin", org?._id
      orgUsers: Roles.getUsersInRole "user", org?._id
  }
    

Router.route "/newOrganization", () ->
  @render "newOrg", {
    data: () ->
      orgs: Orgs
  }

Router.route "/join/:inviteId", () ->
  invite = Invites.findOne(@params.inviteId)
  @render "join", {
    data: () ->
      invite: invite
      org: Orgs.findOne(invite?.org)    
  }