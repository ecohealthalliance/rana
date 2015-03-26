getCollections = => @collections

keyToLabel = (key)->
  label = key[0].toUpperCase()
  for c in key.substr(1)
    if c == c.toUpperCase()
      label += " " + c.toLowerCase()
    else
      label += c
  return label

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
              {label: keyToLabel(item), value: item}
          )
    'filters.$.predicate':
      type: String
      autoform:
        afFieldInput:
          value: "="
          options: [
            {label: "is", value: "="}
            {label: "is greater than", value: ">"}
            {label: "is less than", value: "<"}
          ]
    'filters.$.value':
      type: String
      optional: true
  ))
  @filterCollection.insert({
    filters: []
  })

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

  reportSchema = collections.Reports.simpleSchema().schema()
  @autorun ()=>
    filterSpec = @filterCollection.findOne()?.filters or []
    filters = filterSpec.map (filterSpecification)->
      filter = {}
      value = filterSpecification['value']
      property = filterSpecification['property']
      if value and reportSchema[property].type == Number
        value = parseFloat(value)
      if not value
        filter[property] = {
          $exists: true
        }
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
    .map((report)->
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
    data.forEach((mapItem)->
      L.marker(mapItem.location).addTo(markers)
        .bindPopup(mapItem.popupHTML)
    )
    markers.addTo(lMap)

Template.map.mapQueries = ->
  Template.instance().filterCollection

Template.map.mapQuery = ->
  Template.instance().filterCollection.findOne()

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
        $regex: "^" + RegExp.escape($(e.target).val())
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
