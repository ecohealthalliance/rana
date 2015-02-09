gmap =
  map: null,
  markers: [],

  addMarker: (marker) ->
    gLatLng = new google.maps.LatLng marker.lat, marker.lng
    gMarker = new google.maps.Marker
      position: gLatLng,
      map: this.map,
      title: marker.title,
      icon: 'http://maps.google.com/mapfiles/ms/icons/blue-dot.png'
    gMarker

    @marker = undefined

  setMarker: (location, zoom=0) ->
    $('#lon').val location.lng()
    $('#lat').val location.lat()

    updateUTMFromLonLat()

    if @marker then @marker.setMap null
    @marker = new google.maps.Marker
        position: location
        map: @map
    if zoom > 0
        @map.setZoom zoom


  initialize: () ->
    console.log 'init'
    mapOptions =
      zoom: 12
      center: new google.maps.LatLng 53.565, 10.001
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map document.getElementById('gmap-canvas'), mapOptions

    input = document.getElementById('gmap-search')
    @map.controls[google.maps.ControlPosition.TOP_LEFT].push input
    @searchBox = new google.maps.places.SearchBox input

    google.maps.event.addListener @searchBox, 'places_changed', =>
      location = @searchBox.getPlaces()[0].geometry.location
      @setMarker location
      @map.setCenter location

    google.maps.event.addListener @map, 'click', (e) =>
      @setMarker e.latLng

    $('#lat, #lon').change (e) =>
      updateUTMFromLonLat()
      latlng = new google.maps.LatLng $('#lat').val(), $('#lon').val()
      gmap.setMarker latlng
      gmap.map.setCenter latlng

    $('#northing, #easting, #zone').change (e) =>
      updateLonLatFromUTM()
      $('#locationSource').val 'utm'

    Session.set 'gmap', true

lon2UTMZone = (lon) ->
  Math.min(Math.floor((lon + 180) / 6), 60) + 1

updateUTMFromLonLat = () ->
  lon = parseFloat($('#lon').val())
  lat = parseFloat($('#lat').val())
  zone = lon2UTMZone(lon)

  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj =  proj4.Proj('WGS84')
  utm = proj4.transform(lonlatProj, utmProj, [lon, lat])
  $('#easting').val utm.x
  $('#northing').val utm.y
  $('#zone').val zone

updateLonLatFromUTM = () ->
  easting = parseFloat($('#easting').val())
  northing = parseFloat($('#northing').val())
  zone = parseInt($('#zone').val())

  utmProj = proj4.Proj('+proj=utm +zone=' + String(zone))
  lonlatProj =  proj4.Proj('WGS84')
  lonLat = proj4.transform(utmProj, lonlatProj, [easting, northing])

  location = new google.maps.LatLng lonLat.y, lonLat.x
  gmap.setMarker location
  gmap.map.setCenter location

Template.gmap.events
  'click #gmap-locate': (e, t) ->
      e.preventDefault()

      unless navigator.geolocation then return false

      navigator.geolocation.getCurrentPosition (position) =>
          location = new google.maps.LatLng position.coords.latitude, position.coords.longitude
          gmap.setMarker location
          gmap.map.setCenter location
          $('#gmap-search').val ''
          $('#locationSource').val 'map'

  'change #lat, #lon': (e) ->
    updateUTMFromLonLat()
    $('#locationSource').val 'LonLat'
    latlng = new google.maps.LatLng $('#lat').val, $('#lon').val
    gmap.setMarker latlng

  'change #northing, #easting, #zone': (e) ->
    updateLonLatFromUTM()
    $('#locationSource').val 'utm'

Template.gmapForm.rendered = () ->
  if ! Session.get('gmap')
    gmap.initialize()
