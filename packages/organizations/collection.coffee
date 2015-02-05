Orgs = new Mongo.Collection 'organizations'

Orgs.allow {
  insert: (userId, doc) ->
    if userId
      true
  update: (userId, doc) ->
    if Roles.userIsInRole userId, 'admin', doc._id
      true
}

Orgs.after.insert (userId, doc) ->
  Roles.addUsersToRoles userId, 'admin', @._id

OrgSchema = new SimpleSchema {
  name: {
    type: String
    label: "Organization name"
    max: 100
  },
  path: {
    type: String
    label: "URL path for the organization - #{Meteor.absoluteUrl('org/*path*')}"
    max: 20
    unique: true
  },
  description: {
    type: String
    label: "Short description of the organization"
    max: 200
  }
}

Orgs.attachSchema OrgSchema

@Orgs = Orgs