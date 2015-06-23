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
  lMap = L.map(@$('.vis-map')[0], 
      maxBounds: L.latLngBounds(L.latLng(-85, -180), L.latLng(85, 180))
    ).setView([10, -0], 2)
  L.tileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png', {
    attribution: """Map tiles by <a href="http://cartodb.com/attributions#basemaps">CartoDB</a>, under <a href="https://creativecommons.org/licenses/by/3.0/">CC BY 3.0</a>. Data by <a href="http://www.openstreetmap.org/">OpenStreetMap</a>, under ODbL.
    <br>
    CRS:
    <a href="http://wiki.openstreetmap.org/wiki/EPSG:3857" >
    EPSG:3857
    </a>,
    Projection: Spherical Mercator""",
    subdomains: 'abcd',
    type: 'osm'
    minZoom: 2
    maxZoom: 18
    noWrap: true
  }).addTo(lMap)
  L.control.scale().addTo(lMap)

  markers = new L.FeatureGroup()

  @autorun ()=>
    data = getCollections().Reports.find(Template.instance().query.get())

    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    curGroupBy = Template.instance().groupBy.get()
    colors = [
      '#BC6A28'
      '#C78DCA'
      '#86C8DF'
      '#6354BF'
      '#FDAE61'
      '#00A453'
      '#C10004'
      '#363636'
      '#2C7BB6'
    ]
    groups = []
    if curGroupBy
      getGroup = (report) ->
        keys = curGroupBy.split "."
        result = report
        for key in keys
          result = result?[key]
        if _.isArray result
          # Combine array keys into a human readable string using the schema
          reportSchema = collections.Reports.simpleSchema().schema()
          schemaOptions = reportSchema[curGroupBy].autoform.options
          readableResult = _.filter(schemaOptions, (option) ->
            _.contains(result, option.value)
          )
          readableResult = _.map(readableResult, (schemaOption) ->
            schemaOption.label
          )
          readableResult.sort().join(", ")
        else
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
      if report.eventLocation and report.eventLocation isnt "," and report.eventLocation isnt null
        
        mapPath = Router.path 'map'
        editPath = Router.path 'editReport', {reportId: report._id}, {query: "redirectOnSubmit=#{mapPath}"}
        numInvolvedOpts = getCollections().Reports
          .simpleSchema()
          .schema()
          .numInvolved.autoform.afFieldInput.options
        formattedNumInvolved = _.findWhere(numInvolvedOpts, {
          value: report.numInvolved
        })?.label
        
        L.marker(report.eventLocation.geo.coordinates.reverse(), {
          icon: L.divIcon({
            className: 'map-marker-container'
            iconSize:null
            html:"""
            <div class="map-marker" style="color:#{color};">
            </div>
            """
          })
        }).addTo(markers).bindPopup(
          Blaze.toHTMLWithData(Template.mapPopup, {
            studyName: getCollections().Studies.findOne(report.studyId).name
            report: report
            editPath: editPath
            formattedNumInvolved: formattedNumInvolved
          })
        )
    )
    markers.addTo(lMap)

Template.map.events
  'click .toggle-group': () ->
    $('.group-wrap').toggleClass('hidden showing')
    $('.toggle-group').toggleClass('active')
  'click .toggle-filter': () ->
    $('.map-filters').toggleClass('hidden showing')
    $('.toggle-filter').toggleClass('active')

