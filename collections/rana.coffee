Meteor.startup () ->
  if Meteor.isServer
    unless Groups.findOne {path: 'rana'}
      Groups.insert 
        name: 'rana'
        path: 'rana'
        description: 'Global Ranavirus Reporting System'
        info: """
          ## Ranavirus Information

          - [Historical vertebrate Ranavirus reference list](http://www.ranavirus.org/resources/sample-page/)
          - [List of laboratories that test for ranavirus](http://www.ranavirus.org/resources/testing-labs/)
          - [PARC: Partners in Amphibian and Reptile Conservation website](http://parcplace.org/)
          - [SEPARC information sheets (in transition)](http://www.separc.org/products/diseases-and-parasites-of-herpetofauna)
          - [AmphibiaWeb](http://amphibiaweb.org/)
          """