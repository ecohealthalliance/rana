getCollections = => @collections
Template.map.rendered = ->
  collections = getCollections()
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"
  map = L.map('map').setView([0, -0], 2)
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  
  collections.Reports.find().forEach((report)->
    console.log report
    if report?.location
      locationArray = report.location.split(',').map(parseFloat)
      L.marker(locationArray).addTo(map)
        .bindPopup("#{report.name}'s report")
  )
