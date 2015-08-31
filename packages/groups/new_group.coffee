Groups = share.Groups

AutoForm.hooks
  "new-group-form":
    onSuccess: (operation, result, template) ->\
      Meteor.subscribe "groupById", result, {
        onError: (err) ->
          console.log "error", err
        onReady: () ->
          groupPath = Groups.findOne(result)?.path
          Router.go 'groupHome', {groupPath: groupPath}
      }
      