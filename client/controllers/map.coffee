getCollections = => @collections

Template.map.created = ->
  @query = new ReactiveVar()
  @groupBy = new ReactiveVar()
  @groups = new ReactiveVar()

Template.map.groupBy = ->
  Template.instance().groupBy

Template.map.groups = ->
  Template.instance().groups.get()

Template.map.query = ->
  Template.instance().query

Template.map.rendered = ->
  L.Icon.Default.imagePath = "/packages/fuatsengul_leaflet/images"
  lMap = L.map(@$('.vis-map')[0]).setView([0, -0], 2)
  L.tileLayer('//{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
    attribution: """Map tiles by <a href="http://cartodb.com/attributions#basemaps">CartoDB</a>, under <a href="https://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>. Data by <a href="http://www.openstreetmap.org/">OpenStreetMap</a>, under ODbL.
    <br>
    CRS:
    <a href="http://wiki.openstreetmap.org/wiki/EPSG:3857" >
    EPSG:3857
    </a>,
    Projection: Spherical Mercator""",
    subdomains: 'abcd',
    type: 'osm'
    maxZoom: 18
  }).addTo(lMap)
  L.control.scale().addTo(lMap)

  markers = new L.FeatureGroup()

  @autorun ()=>
    data = getCollections().Reports.find(Template.instance().query.get())

    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    curGroupBy = Template.instance().groupBy.get()
    colors = [
      '#86C8DF'
      '#C78DCA'
      '#2C7BB6'
      '#6354BF'
      '#FDAE61'
      '#00A453'
      '#C10004'
      '#363636'
      '#726258'
    ]
    groups = []
    if curGroupBy
      getGroup = (report) ->
        keys = curGroupBy.split "."
        result = report
        for key in keys
          result = result?[key]
        result

      groups = _.uniq(data.map((report)->
        getGroup(report)
      )).map((value, idx) ->
        name: value
        color: colors[idx]
      )
      if groups.length > colors.length
        alert("This field has too many values to group")
        curGroupBy = null
        groups = []
    Template.instance().groups.set(groups)
    data?.forEach((report)->
      if curGroupBy
        color = _.findWhere(groups, {
          name: getGroup(report)
        }).color
      else
        color = colors[0]
      studyName = getCollections().Studies.findOne(report.studyId).name
      if report.eventLocation and report.eventLocation isnt "," and report.eventLocation isnt null
        L.marker(report.eventLocation.geo.coordinates.reverse(), {
          icon: L.divIcon({
            className: 'map-marker-container'
            iconSize:null
            html:"""
            <div class="map-marker" style="color:#{color};">
            </div>
            """
          })
        })
        .addTo(markers)
        .bindPopup("""
        <div class="map-popup">
        <dl>
          <dt>Study</dt>
          <dd>#{studyName}</dd>
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

Template.map.events
  'click .toggle-group': () ->
    $('.group-wrap').toggleClass('hidden showing')
    $('.toggle-group').toggleClass('active')
  'click .toggle-filter': () ->
    $('.map-filters').toggleClass('hidden showing')
    $('.toggle-filter').toggleClass('active')

