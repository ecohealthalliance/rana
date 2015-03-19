getCollections = => @collections

Template.map.rendered = ->
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"
  lMap = L.map(@$('.vis-map')[0]).setView([0, -0], 2)
  L.tileLayer('//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18
    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(lMap);
  
  # initialize markers
  markers = new L.FeatureGroup()
  markers.addTo(lMap)
  
  @autorun ()=>
    data = getCollections().Reports.find(
      $and: [
        {
          eventLocation: { $ne : null }
        }
        {
          eventLocation: { $ne : ","}
        }
      ]
    )
    .map((report)-> {
      location: report.eventLocation.split(',').map(parseFloat)
      popupHTML: """
      <div>
      <dl>
        <dt>Date</dt>
        <dd>#{report.eventDate}</dd>
        <dt>Type of population</dt>
        <dd>#{report.populationType}</dd>
        <dt>Vertebrate classes</dt>
        <dd>#{report.vertebrateClasses}</dd>
        <dt>Species affected name</dt>
        <dd>#{report.speciesName}</dd>
        <dt>Number of individuals involved</dt>
        <dd>#{report.numInvolved}</dd>
        <dt>Reported By</dt>
        <dd>#{report.createdBy.name}</dd>
      </dl>
      <a class="btn btn-primary btn-edit" href="/form/#{report._id}?redirectOnSubmit=/map">View/Edit</a>
      </div>
      """
    })
    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    data.forEach((mapItem)->
      L.marker(mapItem.location).addTo(markers)
        .bindPopup(mapItem.popupHTML)
    )
    markers.addTo(lMap)

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
