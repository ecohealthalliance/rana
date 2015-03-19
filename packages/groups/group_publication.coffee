Groups = @Groups

publishGroup = (query) ->
  
  result = [Groups.find query]
  
  groupId = Groups.findOne(query)?._id
  
  if Roles.userIsInRole @userId, 'admin', groupId
    # https://waffle.io/ecohealthalliance/rana/cards/54dbc58335ed7b03007bb89e
    result.push Meteor.users.find({}, {fields: {emails: 1, roles: 1, profile: 1}})
    
  result
  
Meteor.publish "groupByPath", (path) ->
  publishGroup.call @, {path: path}
  
Meteor.publish "groupById", (id) ->
  publishGroup.call @, {_id: id}