Groups = new Mongo.Collection 'groups'

Groups.allow {
  insert: (userId, doc) ->
    if userId
      true
  update: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', doc._id
      true
}

GroupSchema = new SimpleSchema {
  name: {
    type: String
    label: "Group name"
    max: 100
  },
  path: {
    type: String
    unique: true
    autoform:
      type: "hidden"
      label: false
  },
  description: {
    type: String
    label: "Short description of the group"
    max: 200
  },
  info: {
    type: String
    label: "Information about the group"
    optional: true
    autoform:
      rows: 20
  }
}

GroupSchema.messages {
  "notUnique path": "The group name is too similar to an existing group."
}

Groups.before.insert (userId, doc) ->
  doc.path = doc.name.toLowerCase().replace /[^a-z0-9]+/g, '-'

Groups.after.insert (userId, doc) ->
  if @._id
    if userId
      Roles.addUsersToRoles userId, ['admin', 'user'], @._id
    else
      # first user to log in will be an admin of the group
      handle = null
      groupId = @._id
      createAdminUser = (loginInfo) ->
        userId = loginInfo.user._id
        Roles.addUsersToRoles userId, ['admin', 'user'], groupId
        handle.stop()
      handle = Accounts.onLogin createAdminUser

Groups.attachSchema GroupSchema

share.Groups = Groups
