# This is only global so it can be initialized in the test fixtures.
@__SpeciesCollection = new Mongo.Collection 'species'

Meteor.methods

  getSpeciesBySynonym: (synonym) =>
    @__SpeciesCollection.find({ lowerCaseSynonyms: synonym.toLowerCase() }).fetch()
