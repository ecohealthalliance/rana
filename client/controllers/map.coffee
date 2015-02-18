Template.map.rendered = ->
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"
  map = L.map(@$('.vis-map')[0]).setView([0, -0], 2)
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);
  @data.forEach((mapItem)->
    L.marker(mapItem.location).addTo(map)
      .bindPopup(mapItem.popupHTML)
  )

Template.map.mapSidebarSchema = ->
  new SimpleSchema(
    filters:
      type: Array
      optional: true
    'filters.$':
      type: Object
      optional: true
    'filters.$.property':
      type: String
      autoform:
        afFieldInput:
          options: [
            "number infected",
            "species"
          ].map((v)->{value: v, label: v})
    'filters.$.value':
      type: String
  )

Template.map.mapQueries = ->
  new Meteor.Collection()

Template.map.mapQuery = ->
  {filters:[]}
