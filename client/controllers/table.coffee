getCollections = => @collections

Template.table.created = ->
  @query = new ReactiveVar()

Template.table.query = ->
  Template.instance().query

Template.table.filters = =>
  filters = []
  query = Template.instance().query.get() or {}
  # reactive-table filters don't support arbitrary queries yet
  queries = if '$and' of query then query['$and'] else [query]
  for q in queries
    key = Object.keys(q)[0]
    value = q[key] or ""
    filter = new ReactiveTable.Filter('reports-' + key, [key])
    if value isnt filter.get()
      filter.set(value)
    filters.push 'reports-' + key
  filters

Template.table.settings = =>
  isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})._id
  schema = @collections.Reports.simpleSchema().schema()

  fields = []
  
  studyVars = {}
  getStudyNameVar = (studyId) ->
    if studyVars[studyId]
      return studyVars[studyId]
    else
      studyNameVar = new ReactiveVar("")
      studyVars[studyId] = studyNameVar
      onReady = () ->
        studyName = getCollections().Studies.findOne(studyId)?.name
        studyNameVar.set studyName
      Meteor.subscribe "studies", studyId, onReady
      return studyNameVar

  fields.push
    key: "studyId"
    label: "Study"
    fn: (val, obj) ->
      getStudyNameVar(val).get()

  fields.push
    key: "eventLocation"
    label: "Event Location"
    fn: (val, obj) ->
      if val
        String(val.geo.coordinates[0]) + ', ' + String(val.geo.coordinates[1])
      else
        ''

  columns = [
    "speciesGenus"
    "speciesName"
    "screeningReason"
    "populationType"
  ]
  for key in columns
    do (key) ->
      label = schema[key].label or key
      if label.length > 30
        label = key
      fields.push
        key: key
        label: label
        fn: (val, object) ->
          if schema[key]?.autoform?.afFieldInput?.options
            option = _.findWhere(
              schema[key].autoform.afFieldInput.options,
              value: val
            )
            display = option?.label or ''
            new Spacebars.SafeString("<span sort=#{sort}>#{display}</span>")
          else
            output = val or ''

            # capitalize first letter
            if output.length > 1
              output = output.charAt(0).toUpperCase() + output.slice(1)

            # truncate long fields
            if output.length > 100
              output = output.slice(0, 100) + '...'

            # put empty values at the end
            if output is '' then sort = 2 else sort = 1

            if not output
              output = ''

            # use option labels instead of values
            new Spacebars.SafeString("<span sort=#{sort}>#{output}</span>")

  fields.push
    key: "createdBy.name"
    label: "Submitted by"

  fields.push
    key: "controls"
    label: ""
    hideToggle: true
    fn: (val, obj) ->
      if obj.createdBy.userId == Meteor.userId() or isAdmin
        new Spacebars.SafeString("""
          <a class="btn btn-edit btn-primary" href="/report/#{obj._id}?redirectOnSubmit=/table">Edit</a>
          <a class="btn btn-danger remove remove-form" data-id="#{obj._id}">Remove</a>
        """)
      else
        new Spacebars.SafeString("""
          <a class="btn btn-primary" href="/report/#{obj._id}">View</a>
        """)

  showColumnToggles: true
  showFilter: false
  fields: fields
  noDataTmpl: Template.noReports

Template.table.events(
  'click .remove-form': (evt)->
    reportId = $(evt.target).data("id")
    reply = prompt('Type "delete" to confirm that this report should be removed.')
    if reply == "delete"
      getCollections().Reports.remove(reportId)

  'click .toggle-filter': () ->
    $('.filter-controls').toggleClass('hidden')
    $('.toggle-filter').toggleClass('showingOpts')

  'click .export': (event, template) ->
    $(event.target).addClass('disabled')
    query = template.query.get()
    Meteor.call 'export', query, (err, result) ->
      if (err)
        console.log err
        alert "There was an error exporting the data."
      else
        window.open "data:text/csv;charset=utf-8," + encodeURIComponent(result)
      $(event.target).removeClass('disabled')
)
