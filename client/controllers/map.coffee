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
    attribution: """&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>""",
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
    groups = []
    if curGroupBy
      groups = _.uniq(data.map((report)->
        report[curGroupBy]
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
          name: report[curGroupBy]
        }).color
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
        <div class="map-popup">
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

Template.map.events
  'click .toggle-group': () ->
    $('.group-wrap').toggleClass('hidden showing')
    $('.toggle-group').toggleClass('active')
  'click .toggle-filter': () ->
    $('.filter-wrap').toggleClass('hidden showing')
    $('.toggle-filter').toggleClass('active')

