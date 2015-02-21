Meteor.publish 'mappings', ->
  collections.Mappings.find()

