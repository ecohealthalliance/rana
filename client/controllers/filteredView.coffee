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

Template.filteredView.created = ->
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

Template.filteredView.filterCollection = ->
  Template.instance().filterCollection

Template.filteredView.filter = ->
  Template.instance().filterCollection.findOne()

Template.filteredView.filteredData = ->
  reportSchema = collections.Reports.simpleSchema().schema()
  filterSpec = Template.instance().filterCollection.findOne()?.filters or []
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
  getCollections().Reports.find(
    $and: [
      {
        eventLocation: { $ne : null }
      }
      {
        eventLocation: { $ne : ","}
      }
    ].concat(filters)
  )

Template.filteredView.events
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