SimpleSchema.debug = true

SimpleSchema.messages
  needsLatLong: '[label] should be of form [latitude, longitude]'
  latOutOfRange: '[label] latitude should be between -90 and 90'
  lonOutOfRange: '[label] longitude should be between -180 and 180'
  northing: '[label] northing should be between 0 and 10,000,000'
  easting: '[label] easting should be between 0 and 1,000,000'
  zone: '[label] zone should be between 1 and 60. North or south can be appended to specify the hemisphere.'
  degressLonOutOfRange: '[label] longitude degrees should be between -180 and 180'
  minutesLonOutOfRange: '[label] latitude minutes should be between 1 and 60'
  secondsLonOutOfRange: '[label] latitude seconds should be between 1 and 60'
  degreesLatOutOfRange: '[label] latitude degrees should be between -90 and 90'
  minutesLatOutOfRange: '[label] latitude minutes should be between 1 and 60'
  secondsLatOutOfRange: '[label] latitude seconds should be between 1 and 60'

@locationSchema = new SimpleSchema
  source:
    type: String
    allowedValues: [ 'LonLat', 'MinSec', 'utm', 'map', 'UTM' ]
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
    type: String
    custom: ->
      [zoneNum, hemisphere] = @value.split(' ')
      if parseInt(zoneNum, 10) < 1
        return 'zone'
      else if parseInt(zoneNum, 10) > 60
        return 'zone'
      else if hemisphere
        if hemisphere.toLowerCase() != 'north' and hemisphere.toLowerCase() != 'south'
          return 'zone'
  degreesLon:
    type: Number
    custom: ->
      return 'degreesLon' unless -180 <= @value <= 180
  secondsLon:
    type: Number
    decimal: true
    custom: ->
      return 'secondsLon' unless 0 <= @value < 60
  minutesLon:
    type: Number
    custom: ->
      return 'minutesLon' unless 0 <= @value < 60
  degreesLat:
    type: Number
    custom: ->
      return 'degreesLat' unless -90 <= @value <= 90
  secondsLat:
    type: Number
    decimal: true
    custom: ->
      return 'secondsLat' unless 0 <= @value < 60
  minutesLat:
    type: Number
    custom: ->
      return 'minutesLat' unless 0 <= @value < 60
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
