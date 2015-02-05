Orgs = @Orgs

AutoForm.hooks
  "new-org-form":
    onSuccess: (operation, result, template) ->
      orgPath = Orgs.findOne(result).path
      Router.go "/org/#{orgPath}"
      