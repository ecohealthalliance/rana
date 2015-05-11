images = [
  {file:'cressier_01', credit: 'Image: Alan Cressier'},
  {file: 'cressier_02', credit: 'Image: Alan Cressier'},
  {file: 'cressier_03', credit: 'Image: Alan Cressier'},
  {file: 'cressier_04', credit: 'Image: Alan Cressier'},
  {file: 'cressier_05', credit: 'Image: Alan Cressier'},
  {file: 'cressier_06', credit: 'Image: Alan Cressier'},
  {file: 'lesions-Pelophylax-sp-Netherlands-Aug2013_01', credit: 'Image: Annemarieke Spitzen'},
  {file: 'LESIONS', credit: 'Image: Jesse Brunner'},
  {file: 'LiverNecrosis_DebraMiller', credit: 'Image: Debra Miller'},
  {file: 'symptoms-Pelophylax-spp-Netherlands-Aug2013-02', credit: 'Image: Annemarieke Spitzen'},
  {file: 'Swollen-legs_PSTR_PhotoCredit_Mihaljevic', credit: 'Mihaljevic'}
]

allImages = ""
_.each(images, (image, i) ->
    allImages += "[![Image #{i}](../../../images/info/thumbs/#{image.file}_t.jpg '#{image.credit}')](../../../images/info/#{image.file}.jpg)"
  )

Meteor.startup () ->
  if Meteor.isServer
    unless Groups.findOne {path: 'rana'}
      Groups.insert 
        name: 'Rana'
        path: 'rana'
        description: 'Global Ranavirus Reporting System'
        info: """
          ## Ranavirus Information

          ### Links

          - [Global Ranavirus Consortium Publications](http://www.ranavirus.org/resources/sample-page/)
          - [List of laboratories that test for ranavirus](http://www.ranavirus.org/resources/testing-labs/)
          - [PARC: Partners in Amphibian and Reptile Conservation website](http://parcplace.org/)
          - [SEPARC information sheets (in transition)](http://www.separc.org/products/diseases-and-parasites-of-herpetofauna)
          - [AmphibiaWeb](http://amphibiaweb.org/)

          ### Photos

            #{allImages}

          """

