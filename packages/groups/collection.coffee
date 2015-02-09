Groups = new Mongo.Collection 'groups'

Groups.allow {
  insert: (userId, doc) ->
    if userId
      true
  update: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', doc._id
      true
}

Groups.after.insert (userId, doc) ->
  Roles.addUsersToRoles userId, ['admin', 'user'], @._id

GroupSchema = new SimpleSchema {
  name: {
    type: String
    label: "Group name"
    max: 100
  },
  path: {
    type: String
    label: "URL path for the group - #{Meteor.absoluteUrl('group/*path*')}"
    max: 20
    unique: true
  },
  description: {
    type: String
    label: "Short description of the group"
    max: 200
  }
}

Groups.attachSchema GroupSchema

@Groups = Groups