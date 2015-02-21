defaults =
  defaultLat: 48.856614
  defaultLon: 2.3522219000000177
  defaultZoom: 13

AutoForm.addInputType 'gmap',
  template: 'gmap'
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

Template.gmap.helpers
  schemaKey: ->
    @atts['data-schema-key']

Template.gmap.rendered = ->

  @data.options = _.extend {}, defaults, @data.atts

  @data.canvas = @$('.gmap-canvas')[0]
  @data.canvas = @data.canvas

  @data.map = null
  @data.marker = null

  @data.setMarker = (location, zoom=0) =>

    $(@$('.lon')[0]).val location.lng()
    $(@$('.lat')[0]).val location.lat()

    @data.updateUTMFromLonLat()

    if @data.marker then @data.marker.setMap null
    @data.marker = new google.maps.Marker
      position: location
      map: @data.map
    if zoom > 0
      @data.map.setZoom zoom

  @data.lon2UTMZone = (lon) ->
    Math.min(Math.floor((lon + 180) / 6), 60) + 1

  @data.updateUTMFromLonLat = () =>
    lon = parseFloat($(@$('.lon')[0]).val())
    lat = parseFloat($(@$('.lat')[0]).val())
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

    utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
    lonlatProj =  proj4.Proj('WGS84')
    lonLat = proj4.transform(utmProj, lonlatProj, [easting, northing])

    location = new google.maps.LatLng lonLat.y, lonLat.x
    @data.setMarker location
    @data.map.setCenter location

  @data.reset = () =>
    if @data.marker then @data.marker.setMap null
    @data.map.setCenter new google.maps.LatLng @data.options.defaultLat, @data.options.defaultLon
    @data.map.setZoom @data.options.defaultZoom

  mapOptions =
    zoom: @data.options.defaultZoom
    center: new google.maps.LatLng @data.options.defaultLat, @data.options.defaultLon
    mapTypeId: google.maps.MapTypeId.ROADMAP

  @data.map = new google.maps.Map @data.canvas, mapOptions

  input = @$('.gmap-search')[0]

  @data.map.controls[google.maps.ControlPosition.TOP_LEFT].push input
  @data.searchBox = new google.maps.places.SearchBox input

  google.maps.event.addListener @data.searchBox, 'places_changed', =>
    location = @data.searchBox.getPlaces()[0].geometry.location
    @data.setMarker location
    @data.map.setCenter location

  google.maps.event.addListener @data.map, 'click', (e) =>
    $(@$('.source')[0]).val 'map'
    @data.setMarker e.latLng

  @$('.gmap-canvas').closest('form').on 'reset', =>
    @data.reset()


Template.gmap.events

  'click .gmap-locate': (e, t) ->
    e.preventDefault()

    unless navigator.geolocation then return false

    navigator.geolocation.getCurrentPosition (position) =>
      location = new google.maps.LatLng position.coords.latitude, position.coords.longitude
      @setMarker location
      @map.setCenter location
      $(t.$('.gmap-search')[0]).val ''
      $(t.$('.source')[0]).val 'map'

  'click .gmap-clear': (e, t) ->
    e.preventDefault()

    $(t.$('.gmap-search')[0]).val ''
    $(t.$('.lon')[0]).val ''
    $(t.$('.lat')[0]).val ''
    $(t.$('.northing')[0]).val ''
    $(t.$('.easting')[0]).val ''
    $(t.$('.zone')[0]).val ''
    $(t.$('.source')[0]).val ''

    if @marker then @marker.setMap null

  'change .lat, change .lon': (e, t) ->
    t.data.updateUTMFromLonLat()
    t.$(t.$('.source')[0]).val 'LonLat'
    latlng = new google.maps.LatLng t.$(t.$('.lat')[0]).val(), t.$(t.$('.lon')[0]).val()
    t.data.setMarker latlng
    t.data.map.setCenter latlng

  'change .northing, change .easting, change .zone': (e, t) ->
    t.data.updateLonLatFromUTM()
    t.$(t.$('.source')[0]).val 'utm'

  'click .gmap-reset': (e, t) ->
    if t.data.marker then t.data.marker.setMap null
    t.data.map.setCenter new google.maps.LatLng t.data.options.defaultLat, t.data.options.defaultLon
    t.data.map.setZoom t.data.options.defaultZoom
