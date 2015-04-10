getCollections = => @collections

resolvePath = (path, obj) ->
  if _.isString(path)
    return resolvePath(path.split('.'), obj)
  if path.length == 0
    return [obj]
  results = []
  component = path[0]
  if _.isArray(obj[component])
    return _.chain(obj[component])
      .map (subObj)-> resolvePath(path.slice(1), subObj)
      .flatten()
      .value()
  else
    return resolvePath(path.slice(1), obj[component])

Template.map.created = ->
  @filterCollection = new Meteor.Collection(null)
  
  @filterCollection.attachSchema(new SimpleSchema(
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
            "speciesName"
            "speciesGenus"
            "populationType"
            "vertebrateClasses"
            "ageClasses"
            "eventDate"
            "totalAnimalsConfirmedInfected"
            "totalAnimalsConfirmedDiseased"
            {label: "creator", value: "createdBy.name"}
          ].map((item)->
            if _.isObject(item)
              item
            else
              {
                label: getCollections().Reports.simpleSchema().label(item),
                value: item
              }
          )
    'filters.$.predicate':
      type: String
      autoform:
        afFieldInput:
          options: [
            {label: "is", value: "="}
            {label: "is greater than", value: ">"}
            {label: "is less than", value: "<"}
            {label: "is defined", value: "defined"}
            {label: "is not defined", value: "undefined"}
          ]
    'filters.$.value':
      type: String
      optional: true
  ))
  @filterCollection.insert({
    filters: []
  })
  @groupBy = new ReactiveVar()

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

  # initialize markers
  markers = new L.FeatureGroup()
  markers.addTo(lMap)

  reportSchema = collections.Reports.simpleSchema().schema()
  @autorun ()=>
    filterSpec = @filterCollection.findOne()?.filters or []
    filters = filterSpec.map (filterSpecification)->
      filter = {}
      value = filterSpecification['value']
      property = filterSpecification['property']
      if value and reportSchema[property].type == Number
        value = parseFloat(value)
      if value and reportSchema[property].type == Date
        value = new Date(value)
        if ("" + value) == "Invalid Date"
          alert("Invalid Date Format")
          return {}
      if filterSpecification['predicate'] == 'defined'
        filter[property] = {
          $exists: true
        }
      else if filterSpecification['predicate'] == 'undefined'
        filter[property] = {
          $exists: false
        }
      else if not value
        return {}
      else if filterSpecification['predicate'] == '>'
        filter[property] = {
          $gt: value
        }
      else if filterSpecification['predicate'] == '<'
        filter[property] = {
          $lt: value
        }
      else
        filter[property] = value
      return filter
    data = getCollections().Reports.find(
      $and: [
        {
          eventLocation: { $ne : null }
        }
        {
          eventLocation: { $ne : ","}
        }
      ].concat(filters)
    )
    lMap.removeLayer(markers)
    markers = new L.FeatureGroup()
    curGroupBy = @groupBy.get()
    groups = _.uniq(data.map((report)->report[curGroupBy]))
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
    data.forEach((report)->
      if curGroupBy
        groupValue = report[curGroupBy]
        color = colors[groups.indexOf(groupValue)]
      else
        color = colors[0]
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

Template.map.mapQueries = ->
  Template.instance().filterCollection

Template.map.mapQuery = ->
  Template.instance().filterCollection.findOne()

Template.map.groups = ->
  [
    ""
    "speciesName"
    "speciesGenus"
    "populationType"
    "vertebrateClasses"
    "ageClasses"
    "createdBy.name"
  ].map((item)->
      {
        label: getCollections().Reports.simpleSchema().label(item),
        value: item
        selected: item == (Template.instance().groupBy?.get() or "")
      }
  )

Template.map.events
  'click .reset': ()->
    @._af.collection.remove(@._af.doc._id)
    @._af.collection.insert({
      filters: []
    })
  'keyup input[data-schema-key]': _.throttle (e) ->
    schemaKey = $(e.target).data('schema-key')
    schemaKeyComponents = schemaKey.split('.')
    schemaKeyType = schemaKeyComponents.slice(-1)[0]
    schemaKeyIdx = schemaKeyComponents.slice(-2)[0]
    if schemaKeyType == "value"
      filterSpecification = AutoForm.getFormValues("filter-panel").insertDoc.filters[schemaKeyIdx]
      query = {}
      query[filterSpecification.property] = {
        $regex: "^" + utils.regexEscape($(e.target).val())
        $options: "i"
      }
      values = getCollections().Reports
        .find(query, {
          limit: 5
        })
        .map((result)->
          resolvePath(filterSpecification.property, result)
        )
      $("input[name='#{schemaKey}']").autocomplete
        source: _.flatten(values)
  'change #group-by' : (event, template) ->
    Template.instance().groupBy.set($(event.target).val())