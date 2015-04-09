getCollections = => @collections

Template.map.created = ->
  @query = new ReactiveVar()
  @groupBy = new ReactiveVar()

Template.map.groupBy = ->
  Template.instance().groupBy

Template.map.query = ->
  Template.instance().query

Template.map.rendered = ->
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"
  lMap = L.map(@$('.vis-map')[0]).setView([0, -0], 2)
  L.tileLayer('//otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.png', {
    attribution: """
    Map Data &copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors,
    Tiles &copy; <a href="http://www.mapquest.com/" target="_blank">MapQuest</a>
    <img src="http://developer.mapquest.com/content/osm/mq_logo.png" />
    """
    subdomains: '1234'
    type: 'osm'
    maxZoom: 18
  }).addTo(lMap);

  markers = new L.FeatureGroup()

  @autorun ()=>
    data = getCollections().Reports.find(Template.instance().query.get())

    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    curGroupBy = Template.instance().groupBy.get()
    groups = _.uniq(data.map((report)->
      if curGroupBy
        report[curGroupBy]
    ))
    colors = [
      '#8dd3c7'
      '#ffffb3'
      '#bebada'
      '#fb8072'
      '#80b1d3'
      '#fdb462'
      '#b3de69'
      '#fccde5'
      '#d9d9d9'
    ]
    if groups.length > colors.length
      alert("This field has too many values to group")
      curGroupBy = null
    data?.forEach((report)->
      if curGroupBy
        groupValue = report[curGroupBy]
        color = colors[groups.indexOf(groupValue)]
      else
        color = colors[0]
      if report.eventLocation and report.eventLocation isnt "," and report.eventLocation isnt null
        L.marker(report.eventLocation.geo.coordinates.reverse(), {
          icon: L.divIcon({
            className: 'map-marker-container'
            iconSize:null
            html:"""
            <div class="map-marker" style="background-color:#{color};">
              <div class="arrow" style="border-top-color:#{color};"></div>
            </div>
            """
          })
        })
        .addTo(markers)
        .bindPopup("""
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
        <a class="btn btn-primary btn-edit" href="/report/#{report._id}?redirectOnSubmit=/map">
          View/Edit
        </a>
        </div>
        """)
      )
    markers.addTo(lMap)
