defaults =
  defaultLat: 48.856614
  defaultLon: 2.3522219
  defaultZoom: 10

AutoForm.addInputType 'leaflet',
  template: 'leaflet'
  valueOut: ->
    node = $(@context)

    if node.find('.lat').val() != ''
      northing: parseFloat node.find('.northing').val()
      easting: parseFloat node.find('.easting').val()
      zone: parseInt node.find('.zone').val()
      degreesLon: parseFloat node.find('.degreesLon').val()
      minutesLon: parseFloat node.find('.minutesLon').val()
      secondsLon: parseFloat node.find('.secondsLon').val()
      degreesLat: parseFloat node.find('.degreesLat').val()
      minutesLat: parseFloat node.find('.minutesLat').val()
      secondsLat: parseFloat node.find('.secondsLat').val()
      source: node.find('.source').val()
      country: node.find('.country').val()
      geo:
        type: 'Point'
        coordinates: [
          parseFloat(node.find('.lon').val()),
          parseFloat(node.find('.lat').val()) ]
    else
      {}
  valueConverters:
    string: (value) ->
      "#{value.lat},#{value.lon}"

Template.leaflet.helpers
  schemaKey: ->
    @atts['data-schema-key']

Template.leaflet.rendered = ->

  @setMarker = (location, zoom=0) =>
    @clearMarker()
    @marker = L.marker(location).addTo(@map)

  @clearMarker = () =>
    if @marker then @map.removeLayer(@marker)

  @updateUTMFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      utm = Mapping.utmFromLonLat lon, lat
      $(@$('.easting')[0]).val utm.easting
      $(@$('.northing')[0]).val utm.northing
      $(@$('.zone')[0]).val utm.zone

  @updateLonLatFromUTM = () =>
    easting = parseFloat($(@$('.easting')[0]).val())
    northing = parseFloat($(@$('.northing')[0]).val())
    zone = parseInt($(@$('.zone')[0]).val())
    if not isNaN(easting) and not isNaN(northing) and not isNaN(zone)
      coords = Mapping.lonLatFromUTM easting, northing, zone
      $(@$('.lat')[0]).val coords.lat
      $(@$('.lon')[0]).val coords.lon

  @updateLonLatFromMinSec = () =>
    degreesLon = parseInt($(@$('.degreesLon')[0]).val())
    minutesLon = parseInt($(@$('.minutesLon')[0]).val())
    secondsLon = parseFloat($(@$('.secondsLon')[0]).val())
    degreesLat = parseInt($(@$('.degreesLat')[0]).val())
    minutesLat = parseInt($(@$('.minutesLat')[0]).val())
    secondsLat = parseFloat($(@$('.secondsLat')[0]).val())

    if ( not isNaN(degreesLon) and not isNaN(minutesLon) and not isNaN(secondsLon) and
         not isNaN(degreesLon) and not isNaN(minutesLon) and not isNaN(secondsLon) )
      lon = Mapping.minSec2Decimal degreesLon, minutesLon, secondsLon
      lat = Mapping.minSec2Decimal degreesLat, minutesLat, secondsLat
      $(@$('.lat')[0]).val lat
      $(@$('.lon')[0]).val lon

  @updateMinSecFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      minSecLon = Mapping.decimal2MinSec lon
      minSecLat = Mapping.decimal2MinSec lat
      $(@$('.degreesLon')[0]).val minSecLon.degrees
      $(@$('.minutesLon')[0]).val minSecLon.minutes
      $(@$('.secondsLon')[0]).val minSecLon.seconds
      $(@$('.degreesLat')[0]).val minSecLat.degrees
      $(@$('.minutesLat')[0]).val minSecLat.minutes
      $(@$('.secondsLat')[0]).val minSecLat.seconds

  @updateViewFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      location = new L.LatLng $(@$('.lat')[0]).val(), $(@$('.lon')[0]).val()
      @setMarker location
      @map.panTo location

  @toggleLoader = (e) =>
    details = $('.location-details')
    if(e)
      $(e.target).attr('disabled', true).addClass('btn-loading')
      details.addClass('loading')
    else
      $('.leaflet-locate').attr('disabled', false).removeClass('btn-loading')
      details.removeClass('loading')

  @reset = () =>
    @clearMarker()
    @map.panTo new L.LatLng(@options.defaultLat, @options.defaultLon)
    @map.setZoom @options.defaultZoom
    $(@$('.leaflet-search')[0]).val ''
    $(@$('.lon')[0]).val ''
    $(@$('.lat')[0]).val ''
    $(@$('.northing')[0]).val ''
    $(@$('.easting')[0]).val ''
    $(@$('.zone')[0]).val ''
    $(@$('.source')[0]).val ''

  @options = _.extend {}, defaults, @data.atts

  @canvas = @$('.leaflet-canvas')[0]
  @canvas = @canvas

  @map = null
  @marker = null

  L.Icon.Default.imagePath = '/packages/fuatsengul_leaflet/images'

  @marker = null

  @map = L.map(@$('.leaflet-canvas')[0]).setView [0, -0], 2
  L.tileLayer('//otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.png', {
    attribution: """
    Map Data &copy; <a href="http://osm.org/copyright" target="_blank">OpenStreetMap</a> contributors,
    Tiles &copy; <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>
    <img src="http://developer.mapquest.com/content/osm/mq_logo.png" />
    <br>
    CRS:
    <a href="http://wiki.openstreetmap.org/wiki/EPSG:3857" target="_blank">
      EPSG:3857
    </a>,
    Projection: Spherical Mercator
    """
    subdomains: '1234'
    type: 'osm'
    maxZoom: 18
  }).addTo(@map)
  L.control.scale().addTo(@map)

  if @data.value
    $(@$('.leaflet-search')[0]).val ''
    $(@$('.lon')[0]).val @data.value.geo.coordinates[0]
    $(@$('.lat')[0]).val @data.value.geo.coordinates[1]
    $(@$('.northing')[0]).val @data.value.northing
    $(@$('.easting')[0]).val @data.value.easting
    $(@$('.zone')[0]).val @data.value.zone
    $(@$('.source')[0]).val @data.value.source
    $(@$('.country')[0]).val @data.value.country
    $(@$('.degreesLon')[0]).val @data.value.degreesLon
    $(@$('.minutesLon')[0]).val @data.value.minutesLon
    $(@$('.secondsLon')[0]).val @data.value.secondsLon
    $(@$('.degreesLat')[0]).val @data.value.degreesLat
    $(@$('.minutesLat')[0]).val @data.value.minutesLat
    $(@$('.secondsLat')[0]).val @data.value.secondsLat
    @updateViewFromLonLat()
    @map.setZoom @options.defaultZoom
  else
    @reset()

  @map.on 'click', (e) =>
    $(@$('.source')[0]).val 'map'
    @setMarker e.latlng
    $(@$('.lat')[0]).val e.latlng.lat
    $(@$('.lon')[0]).val e.latlng.lng
    @updateUTMFromLonLat()
    @updateMinSecFromLonLat()

  @map.on 'locationfound', (e) =>
    $(@$('.source')[0]).val 'map'
    @setMarker e.latlng
    $(@$('.lat')[0]).val e.latlng.lat
    $(@$('.lon')[0]).val e.latlng.lng
    @updateUTMFromLonLat()
    @updateMinSecFromLonLat()
    @map.setView @marker.getLatLng(), @map.getZoom()

    @toggleLoader()


  @$('.leaflet-canvas').closest('form').on 'reset', =>
    @reset()

Template.leaflet.events

  'click .leaflet-locate': (e, t) ->
    e.preventDefault()
    unless navigator.geolocation then return false
    t.toggleLoader(e)
    t.map.locate()

  'click .leaflet-clear': (e, t) ->
    e.preventDefault()
    t.reset()

  'change .lat, change .lon': (e, t) ->
    t.$(t.$('.source')[0]).val 'LonLat'
    t.updateUTMFromLonLat()
    t.updateMinSecFromLonLat()
    t.updateViewFromLonLat()

  'change .northing, change .easting, change .zone': (e, t) ->
    t.$(t.$('.source')[0]).val 'utm'
    t.updateLonLatFromUTM()
    t.updateMinSecFromLonLat()
    t.updateViewFromLonLat()

  'change .degreesLon, change .minutesLon, change .secondsLon, change .degreesLat, change .minutesLat, change .secondsLat': (e, t) ->
    t.$(t.$('.source')[0]).val 'MinSec'
    t.updateLonLatFromMinSec()
    t.updateUTMFromLonLat()
    t.updateViewFromLonLat()
