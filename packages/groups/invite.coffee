Groups = share.Groups

Invites = new Mongo.Collection 'invites'

InviteSchema = new SimpleSchema {
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "Invite an admin by email"
  group:
    type: String
    autoform:
      type: "hidden"
      label: false
}

if Meteor.isClient
  Template.invite.helpers {
    inviteSchema: () -> InviteSchema
  }

if Meteor.isServer

  Meteor.methods {
    invite: (doc) ->
      check doc, InviteSchema
      if Roles.userIsInRole @userId, "admin", doc.group
        
        inviteId = Invites.insert {'email': doc.email, 'group': doc.group}
        groupName = Groups.findOne(doc.group).name

        userEmail = Meteor.users.findOne(@userId).emails[0].address
        joinPath = Router.path 'join', {inviteId: inviteId}
        joinPath = joinPath.slice 1 # remove extra slash

        Email.send {
          from: "#{groupName} Administrator<no-reply@ecohealth.io>"
          to: doc.email
          subject: "Become an admin of #{groupName}"
          text: "You have been invited to become an admin of #{groupName} by #{userEmail}. Visit #{Meteor.absoluteUrl()}#{joinPath} to accept."
        }
      else
        throw new Meteor.Error "403", "user is not a group admin"
        
    join: (inviteId) ->
      if @userId
        invite = Invites.findOne inviteId
        if invite
          Roles.addUsersToRoles @userId, "admin", invite.group
          Invites.remove invite._id
        else
          throw new Meteor.Error "404", "invite not found"
      else
        throw new Meteor.Error "403", "no user signed in"
  }

  Meteor.publish "invite", (inviteId) ->
    groupId = Invites.findOne({_id: inviteId})?.group
    [Invites.find({_id: inviteId}), Groups.find({_id: groupId})]

share.Invites = Invites