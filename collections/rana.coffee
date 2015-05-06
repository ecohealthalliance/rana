images = [
  'cressier_01',
  'cressier_02',
  'cressier_03',
  'cressier_04',
  'cressier_05',
  'cressier_06',
  'lesions-Pelophylax-sp-Netherlands-Aug2013_01',
  'LESIONS',
  'LiverNecrosis_DebraMiller',
  'symptoms-Pelophylax-spp-Netherlands-Aug2013-02',
  'Swollen-legs_PSTR_PhotoCredit_Mihaljevic'
]

allImages = ""
i = 1
_.each(images, (image) ->
    allImages += "[![Image #{i}](../../../images/info/thumbs/#{image}_t.jpg)](../../../images/info/#{image}.jpg)"
    i++
  )

Meteor.startup () ->
  if Meteor.isServer
    unless Groups.findOne {path: 'rana'}
      Groups.insert 
        name: 'rana'
        path: 'rana'
        description: 'Global Ranavirus Reporting System'
        info: """
          # Ranavirus Information

          ## Links

          - [Global Ranavirus Consortium Publications](http://www.ranavirus.org/resources/sample-page/)
          - [List of laboratories that test for ranavirus](http://www.ranavirus.org/resources/testing-labs/)
          - [PARC: Partners in Amphibian and Reptile Conservation website](http://parcplace.org/)
          - [SEPARC information sheets (in transition)](http://www.separc.org/products/diseases-and-parasites-of-herpetofauna)
          - [AmphibiaWeb](http://amphibiaweb.org/)

          ## Photos

            #{allImages}

          """

