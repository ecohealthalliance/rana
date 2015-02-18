Template.join.events {
  "click .join-button": (event, template) ->
    Meteor.call "join", template.data.invite._id, (err, result) ->
      unless err
        Router.go "/group/#{template.data.group.path}"
}
