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
    Meteor.subscribe "groupByPath", @params.groupPath
}


Router.route "/newGroup", {
  data: () ->
    console.log "newGroup data groups", Groups
    groups: Groups
}

Router.route "/join/:inviteId", {
  name: 'join'
  template: 'join'

  data: () ->
    invite = Invites.findOne(@params.inviteId)

    invite: invite
    group: Groups.findOne(invite?.group)

  waitOn: () ->
    Meteor.subscribe "invite", @params.inviteId
}

Router.plugin "ensureSignedIn", {only: ["newGroup", "join"]}