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
    data = Template.currentData().reports

    data = data?.map((report)->
      if report.eventLocation and report.eventLocation isnt "," and report.eventLocation isnt null
        location: [report.eventLocation.geo.coordinates[1], report.eventLocation.geo.coordinates[0]]
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
        <a class="btn btn-primary btn-edit" href="/report/#{report._id}?redirectOnSubmit=/map">View/Edit</a>
        </div>
        """
    )
    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    data?.forEach((mapItem)->
      if mapItem
        L.marker(mapItem.location).addTo(markers)
          .bindPopup(mapItem.popupHTML)
    )
    markers.addTo(lMap)

