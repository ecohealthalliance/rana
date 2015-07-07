AutoForm.hooks
  "update-user-profile-form":
    onSubmit: (insertDoc) ->
      Meteor.users.update Meteor.userId(), {'$set': {'profile': insertDoc}}, (err) ->
        if err
          this.done new Error("failed to update profile")
        else
          this.done()
