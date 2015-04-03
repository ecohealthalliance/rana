SimpleSchema.debug = true

SimpleSchema.messages
  needsLatLong: '[label] should be of form [latitude, longitude]'
  latOutOfRange: '[label] latitude should be between -90 and 90'
  lonOutOfRange: '[label] longitude should be between -180 and 180'
  northing: '[label] northing should be between 0 and 10,000,000'
  easting: '[label] easting should be between 0 and 1,000,000'
  zone: '[label] zone should be between 1 and 60'

@locationSchema = new SimpleSchema
  source:
    type: String
    allowedValues: [ 'LonLat', 'utm', 'map' ]
  northing:
    type: Number
    decimal: true
    custom: ->
      return 'northing' unless 0 <= @value <= 110000000
  easting:
    type: Number
    decimal: true
    custom: ->
      return 'easting' unless 0 <= @value <= 11000000
  zone:
    type: Number
    custom: ->
      return 'zone' unless 1 <= @value <= 60
  geo:
    type: new SimpleSchema
      type:
        type: String
        allowedValues: ['Point']
      coordinates:
        type: [Number]
        decimal: true
        minCount: 2
        maxCount: 2
        custom: ->
          return "needsLatLong" unless @value.length is 2
          return 'lonOutOfRange' unless -180 < @value[0] <= 180
          return 'latOutOfRange' unless -90 <= @value[1] <= 90
  country:
    type: String
