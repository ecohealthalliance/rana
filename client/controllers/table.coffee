getCollections = => @collections

Template.table.isEmpty = =>
  not @collections.Reports.findOne()

Template.table.settings = =>
  isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({})._id
  schema = @collections.Reports.simpleSchema().schema()
  return {
    showColumnToggles: true
    fields: _.map([
      "eventLocation"
      "vertebrateClasses"
      "speciesName"
      "numInvolved"
    ], (key)->
      label = schema[key].label or key
      return {
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
      }
    ).concat([
      {
        key: "createdBy.name"
        label: "Submitted by"
      }
      {
        key: "controls"
        label: ""
        hideToggle: true
        fn: (val, obj)->
          if obj.createdBy.userId == Meteor.userId() or isAdmin
            new Spacebars.SafeString("""
              <a class="btn btn-primary" href="/form/#{obj._id}">Edit</a>
              <a class="btn btn-danger remove-form" data-id="#{obj._id}">Remove</a>
            """)
          else
            new Spacebars.SafeString("""
              <a class="btn btn-primary" href="/form/#{obj._id}">View</a>
            """)
      }
    ])
  }
  
Template.table.events(
  'click .remove-form': (evt)->
    reportId = $(evt.target).data("id")
    reply = prompt('Type "delete" to confirm that this report should be removed.')
    if reply == "delete"
      getCollections().Reports.remove(reportId)
)