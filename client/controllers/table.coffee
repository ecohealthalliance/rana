getCollections = => @collections

Template.table.created = ->
  @query = new ReactiveVar()

Template.table.query = ->
  Template.instance().query

Template.table.isEmpty = ->
  getCollections().Reports.find(Template.instance().query.get()).count() is 0

Template.table.collection = ->
  getCollections().Reports.find(Template.instance().query.get())

Template.table.settings = =>
  isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})._id
  schema = @collections.Reports.simpleSchema().schema()

  fields = []

  fields.push
    key: "studyId"
    label: "Study"
    fn: (val, obj) ->
      getCollections().Studies.findOne(val).name

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

Template.table.events(
  'click .remove-form': (evt)->
    reportId = $(evt.target).data("id")
    reply = prompt('Type "delete" to confirm that this report should be removed.')
    if reply == "delete"
      getCollections().Reports.remove(reportId)
  'click .toggle-filter': () ->
    $('.filter-controls').toggleClass('hidden')
    $('.toggle-filter').toggleClass('showingOpts')
)
