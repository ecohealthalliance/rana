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
  }
}

Groups.before.insert (userId, doc) ->
  doc.path = doc.name.toLowerCase().replace /[^a-z0-9]+/g, '-'

Groups.after.insert (userId, doc) ->
  Roles.addUsersToRoles userId, ['admin', 'user'], @._id
                      
Groups.attachSchema GroupSchema

@Groups = Groups