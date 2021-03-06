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

# Return possible variations in the way a string may be capitalized
expandCase = (strOrArray) ->
  unless _.isArray strOrArray then return expandCase(strOrArray.split(' '))
  words = strOrArray
  if words.length > 3
    console.log(words.join(" ") + " has too many words for case expansion.")
    return [words.join(" ")]
  if words.length == 0 then return []
  word = words[0]
  _.chain([
    word[0].toLowerCase() + word.slice(1)
    word[0].toUpperCase() + word.slice(1)
    word.toLowerCase()
    word
  ])
  .map (wordVariant)->
    if words.length <= 1 then return wordVariant
    _.map expandCase(words.slice(1)), (expandedRemainder)->
      wordVariant + ' ' + expandedRemainder
  .flatten()
  .uniq()
  .value()

Template.filterControls.created = ->
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
            "ranavirusConfirmationMethods"
            "eventLocation.country"
            {label: "Creator", value: "createdBy.name"}
            {label: "Study Name", value: "studyName"}
          ].map((item)->
            if _.isObject(item)
              item
            else
              {
                label: getCollections().Reports.simpleSchema().label(item)
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

Template.filterControls.rendered = ->
  reactiveQuery = Template.currentData().query
  @autorun () =>
    reportSchema = collections.Reports.simpleSchema().schema()
    filterSpec = Template.instance().filterCollection.findOne()?.filters or []
    filterPromises = filterSpec.map (filterSpecification)->
      filter = {}
      value = filterSpecification['value']
      property = filterSpecification['property']
      if property == "studyName"
        return $.Deferred ->
          if filterSpecification['predicate'] != "="
            return @reject "Predicate is not supported for study name."
          Meteor.call "getStudyByName", value, (err, resp)=>
            if err
              @reject err
            else
              if resp?._id
                @resolve {
                  studyId : resp._id
                }
              else
                # Filtering by a value that returns no documents is not an error
                # so this is not rejected.
                @resolve {
                  thisShouldMatchNothing: "true"
                }
        .promise()
      if value and reportSchema[property].type == Number
        value = parseFloat(value)
      if value and reportSchema[property].type == Date
        value = new Date(value)
        if ("" + value) == "Invalid Date"
          return $.Deferred(-> @reject "Invalid Date Format").promise()
      if value and reportSchema[property].type == Array
        # Try to match search terms to the property option labels
        schemaOptions = reportSchema[property].autoform.options
        selectedOption = _.findWhere(schemaOptions, {label: value})
        if selectedOption
          value = selectedOption.value
      if filterSpecification['predicate'] == 'defined'
        filter[property] = {
          $exists: true
        }
      else if filterSpecification['predicate'] == 'undefined'
        filter[property] = {
          $exists: false
        }
      else if not value
        return $.Deferred(-> @reject "No value").promise()
      else if filterSpecification['predicate'] == '>'
        if reportSchema[property].type == String
          return $.Deferred(-> @reject "Invalid predicate").promise()
        filter[property] = {
          $gt: value
        }
      else if filterSpecification['predicate'] == '<'
        if reportSchema[property].type == String
          return $.Deferred(-> @reject "Invalid predicate").promise()
        filter[property] = {
          $lt: value
        }
      else
        filter[property] = {
          $in: expandCase(value)
        }
        if property == "speciesName"
          return $.Deferred ->
            # expand species name queries
            Meteor.call("getSpeciesBySynonym", value, (err, resp)=>
              if err
                return @reject err
              if resp.length > 2
                console.log "Ambiguous species"
              if resp.length == 0
                return @resolve filter
              filter["speciesName"] = {
                $in: _.flatten(_.map(resp[0].synonyms, expandCase))
              }
              @resolve filter
            )
          .promise()
      return $.Deferred(-> @resolve filter).promise()
    $.when.apply(this, filterPromises)
    .then ()=>
      filters = Array.prototype.slice.call(arguments)
      query = {}
      if filters.length > 0
        query = 
          $and: filters
      reactiveQuery.set(query)
    .fail (result)=>
      console.log result
      reactiveQuery.set({
        thisShouldMatchNothing: "true"
      })
      alert(result?.message or result)

Template.filterControls.filterCollection = ->
  Template.instance().filterCollection

Template.filterControls.filter = ->
  Template.instance().filterCollection.findOne()

Template.filterControls.events
  'click .clear': ()->
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
      if filterSpecification.property == "studyName" then return
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
        source: _.uniq(_.flatten(values))
