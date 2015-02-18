Groups = @Groups

AutoForm.hooks
  "new-group-form":
    onSuccess: (operation, result, template) ->
      groupPath = Groups.findOne(result).path
      Router.go "/group/#{groupPath}"
      