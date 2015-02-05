Orgs = @Orgs

Invites = new Mongo.Collection 'invites'

InviteSchema = new SimpleSchema {
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
    label: "Invite a user by email"
  org:
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
      if Roles.userIsInRole @userId, "admin", doc.org
        
        inviteId = Invites.insert {'email': doc.email, 'org': doc.org}
        orgName = Orgs.findOne(doc.org).name

        userEmail = Meteor.users.findOne(@userId).emails[0].address

        Email.send {
          from: "#{orgName} Administrator"
          to: doc.email
          subject: "Join #{orgName}"
          text: "You have been invited to #{orgName} by #{userEmail}. Visit #{Meteor.absoluteUrl()}join/#{inviteId} to join."
        }
      else
        throw new Meteor.Error "403", "user is not an org admin"
        
    join: (inviteId) ->
      if @userId
        invite = Invites.findOne inviteId
        if invite
          Roles.addUsersToRoles @userId, "user", invite.org
          Invites.remove invite._id
        else
          throw new Meteor.Error "404", "invite not found"
      else
        throw new Meteor.Error "403", "no user signed in"
  }

@Invites = Invites