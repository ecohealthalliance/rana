getCollections = => @collections

Template.table.isEmpty = =>
  not @collections.Reports.findOne()

Template.table.settings = =>
  schema = @collections.Reports.simpleSchema().schema()

  fields = []

  fields.push
    key: "eventLocation"
    label: "Event Location"
    fn: (val, obj) ->
      String(val.geo.coordinates[0]) + ', ' + String(val.geo.coordinates[1])

  for key in ["vertebrateClasses", "speciesName", "numInvolved"]
    label = schema[key].label or key
    fields.push
      key: key
      label: (if label.length > 30 then key else label)
      fn: (val) ->
        output = val or ''

        # capitalize first letter
        if output.length > 1
          output = output.charAt(0).toUpperCase() + output.slice(1)

        # truncate long fields
        if output.length > 100
          output = output.slice(0, 100) + '...'

        # put empty values at the end
        if output is '' then sort = 2 else sort = 1

        # use option labels instead of values
        if schema[key]?.autoform?.afFieldInput?.options
          option = _.findWhere(
            schema[key].autoform.afFieldInput.options,
            value: output
          )
          new Spacebars.SafeString("<span sort=#{sort}>#{option?.label}</span>")
        else
          new Spacebars.SafeString("<span sort=#{sort}>#{output}</span>")

  fields.push
    key: "createdBy.name"
    label: "Submitted by"

  fields.push
    key: "controls"
    label: ""
    hideToggle: true
    fn: (val, obj) ->
      if obj.createdBy.userId == Meteor.userId()
        new Spacebars.SafeString("""
          <a class="btn btn-primary" href="/report/#{obj._id}">Edit</a>
          <a class="btn btn-danger remove-form" data-id="#{obj._id}">Remove</a>
        """)
      else
        new Spacebars.SafeString("""
          <a class="btn btn-primary" href="/form/#{obj._id}">View</a>
        """)

  showColumnToggles: true
  fields: fields

Template.table.events(
  'click .remove-form': (evt)->
    reportId = $(evt.target).data("id")
    reply = prompt('Type "delete" to confirm that this report should be removed.')
    if reply == "delete"
      getCollections().Reports.remove(reportId)
)