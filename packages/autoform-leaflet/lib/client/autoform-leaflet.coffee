Mapping = {}

defaults =
  defaultLat: 48.856614
  defaultLon: 2.3522219
  defaultZoom: 10

Mapping.utmFromLonLat = (lon, lat) ->
  zone = Mapping.lon2UTMZone lon
  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj = proj4.Proj('WGS84')
  utm = proj4.transform(lonlatProj, utmProj, [lon, lat])
  { easting: utm.x, northing: utm.y, zone: zone }
utmFromLonLat = Mapping.utmFromLonLat

Mapping.lonLatFromUTM = (easting, northing, zone) ->
  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj =  proj4.Proj('WGS84')
  lonLat = proj4.transform utmProj, lonlatProj, [easting, northing]
  { lon: lonLat.x, lat: lonLat.y }

Mapping.lon2UTMZone = (lon) ->
  Math.floor(((lon + 180) / 6) %% 60) + 1

AutoForm.addInputType 'leaflet',
  template: 'leaflet'
  valueOut: ->
    node = $(@context)

    if node.find('.lat').val() != ''
      northing: parseFloat node.find('.northing').val()
      easting: parseFloat node.find('.easting').val()
      zone: parseInt node.find('.zone').val()
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

  @updateViewFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      location = new L.LatLng $(@$('.lat')[0]).val(), $(@$('.lon')[0]).val()
      @setMarker location
      @map.panTo location

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
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(@map)

  if @data.value
    $(@$('.leaflet-search')[0]).val ''
    $(@$('.lon')[0]).val @data.value.geo.coordinates[0]
    $(@$('.lat')[0]).val @data.value.geo.coordinates[1]
    $(@$('.northing')[0]).val @data.value.northing
    $(@$('.easting')[0]).val @data.value.easting
    $(@$('.zone')[0]).val @data.value.zone
    $(@$('.source')[0]).val @data.value.source
    $(@$('.country')[0]).val @data.value.country
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

  @map.on 'locationfound', (e) =>
    $(@$('.source')[0]).val 'map'
    @setMarker e.latlng
    $(@$('.lat')[0]).val e.latlng.lat
    $(@$('.lon')[0]).val e.latlng.lng
    @updateUTMFromLonLat()
    @map.setView @marker.getLatLng(), @map.getZoom()


  @$('.leaflet-canvas').closest('form').on 'reset', =>
    @reset()

Template.leaflet.events

  'click .leaflet-locate': (e, t) ->
    e.preventDefault()
    unless navigator.geolocation then return false
    t.map.locate()

  'click .leaflet-clear': (e, t) ->
    e.preventDefault()
    t.reset()

  'change .lat, change .lon': (e, t) ->
    t.$(t.$('.source')[0]).val 'LonLat'
    t.updateUTMFromLonLat()
    t.updateViewFromLonLat()

  'change .northing, change .easting, change .zone': (e, t) ->
    t.$(t.$('.source')[0]).val 'utm'
    t.updateLonLatFromUTM()
    t.updateViewFromLonLat()
