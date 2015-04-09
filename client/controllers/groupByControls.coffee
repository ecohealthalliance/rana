getCollections = => @collections

Template.groupByControls.groups = ->
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
        selected: item == (@var?.get() or "")
      }
  )

Template.groupByControls.events
  'change #group-by' : (event, template) ->
    template.data.var.set($(event.target).val())