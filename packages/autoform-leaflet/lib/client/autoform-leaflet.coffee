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
      source: node.find('.source').val()
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

  @data.toggleLoader = (e) =>
    details = $('.location-details')
    if(e)
      $(e.target).attr('disabled', true).addClass('btn-loading')
      details.addClass('loading')
    else 
      $('.leaflet-locate').attr('disabled', false).removeClass('btn-loading')
      details.removeClass('loading')

  @data.setMarker = (location, zoom=0) =>
    @data.clearMarker()
    @data.marker = L.marker(location).addTo(@data.map)

  @data.clearMarker = () =>
    if @data.marker then @data.map.removeLayer(@data.marker)

  @data.lon2UTMZone = (lon) ->
    Math.min(Math.floor((lon + 180) / 6), 60) + 1

  @data.updateUTMFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      zone = @data.lon2UTMZone(lon)

      utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
      lonlatProj =  proj4.Proj('WGS84')
      utm = proj4.transform(lonlatProj, utmProj, [lon, lat])
      $(@$('.easting')[0]).val utm.x
      $(@$('.northing')[0]).val utm.y
      $(@$('.zone')[0]).val zone

  @data.updateLonLatFromUTM = () =>
    easting = parseFloat($(@$('.easting')[0]).val())
    northing = parseFloat($(@$('.northing')[0]).val())
    zone = parseInt($(@$('.zone')[0]).val())
    if not isNaN(easting) and not isNaN(northing) and not isNaN(zone)

      utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
      lonlatProj =  proj4.Proj('WGS84')
      lonLat = proj4.transform utmProj, lonlatProj, [easting, northing]

      $(@$('.lat')[0]).val lonLat.y
      $(@$('.lon')[0]).val lonLat.x

  @data.updateViewFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
    if not isNaN(lon) and not isNaN(lat)
      location = new L.LatLng $(@$('.lat')[0]).val(), $(@$('.lon')[0]).val()
      @data.setMarker location
      @data.map.panTo location

  @data.reset = () =>
    @data.clearMarker()
    @data.map.panTo new L.LatLng(@data.options.defaultLat, @data.options.defaultLon)
    @data.map.setZoom @data.options.defaultZoom
    $(@$('.leaflet-search')[0]).val ''
    $(@$('.lon')[0]).val ''
    $(@$('.lat')[0]).val ''
    $(@$('.northing')[0]).val ''
    $(@$('.easting')[0]).val ''
    $(@$('.zone')[0]).val ''
    $(@$('.source')[0]).val ''

  @data.options = _.extend {}, defaults, @data.atts

  @data.canvas = @$('.leaflet-canvas')[0]
  @data.canvas = @data.canvas

  @data.map = null
  @data.marker = null

  L.Icon.Default.imagePath = '/packages/fuatsengul_leaflet/images'

  @data.marker = null

  @data.map = L.map(@$('.leaflet-canvas')[0]).setView [0, -0], 2
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(@data.map)

  if @data.value
    $(@$('.leaflet-search')[0]).val ''
    $(@$('.lon')[0]).val @data.value.geo.coordinates[0]
    $(@$('.lat')[0]).val @data.value.geo.coordinates[1]
    $(@$('.northing')[0]).val @data.value.northing
    $(@$('.easting')[0]).val @data.value.easting
    $(@$('.zone')[0]).val @data.value.zone
    $(@$('.source')[0]).val @data.value.source
    @data.updateViewFromLonLat()
    @data.map.setZoom @data.options.defaultZoom
  else
    @data.reset()

  @data.map.on 'click', (e) =>
    $(@$('.source')[0]).val 'map'
    @data.setMarker e.latlng
    $(@$('.lat')[0]).val e.latlng.lat
    $(@$('.lon')[0]).val e.latlng.lng
    @data.updateUTMFromLonLat()

  @data.map.on 'locationfound', (e) =>
    $(@$('.source')[0]).val 'map'
    @data.setMarker e.latlng
    $(@$('.lat')[0]).val e.latlng.lat
    $(@$('.lon')[0]).val e.latlng.lng
    @data.updateUTMFromLonLat()
    @data.map.setView @data.marker.getLatLng(), @data.map.getZoom()
    @data.toggleLoader()

  @$('.leaflet-canvas').closest('form').on 'reset', =>
    @data.reset()

Template.leaflet.events

  'click .leaflet-locate': (e, t) ->
    e.preventDefault()
    unless navigator.geolocation then return false
    t.data.toggleLoader(e)
    t.data.map.locate()

  'click .leaflet-clear': (e, t) ->
    e.preventDefault()
    t.data.reset()

  'change .lat, change .lon': (e, t) ->
    t.$(t.$('.source')[0]).val 'LonLat'
    t.data.updateUTMFromLonLat()
    t.data.updateViewFromLonLat()

  'change .northing, change .easting, change .zone': (e, t) ->
    t.$(t.$('.source')[0]).val 'utm'
    t.data.updateLonLatFromUTM()
    t.data.updateViewFromLonLat()
