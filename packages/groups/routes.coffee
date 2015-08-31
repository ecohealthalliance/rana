Groups = share.Groups
Invites = share.Invites

BASE_PATH = '/grrs'

Router.route BASE_PATH + "/group/:groupPath", {

  name: 'groupHome'
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


Router.route BASE_PATH + "/newGroup", {
  name: 'newGroup'
  template: 'newGroup'
  data: () ->
    groups: Groups
}

Router.route BASE_PATH + "/join/:inviteId", {
  name: 'join'
  template: 'join'

  data: () ->
    invite = Invites.findOne(@params.inviteId)

    invite: invite
    group: Groups.findOne(invite?.group)

  waitOn: () ->
    Meteor.subscribe "invite", @params.inviteId
}

Router.route(BASE_PATH + '/group/:groupPath/info',
  name: 'groupInfo'
  where: 'client'
  template: 'groupInfo'
  data: ->
    group: Groups.findOne {path: @params.groupPath}
  waitOn: ->
    Meteor.subscribe "groupByPath", @params.groupPath
)

Router.plugin "ensureSignedIn", {only: ["newGroup", "join"]}