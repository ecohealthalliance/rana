AutoForm.addInputType 'date-parse',
  template: 'dateParse'
  valueIn: (val) ->
    if (val instanceof Date) then val.toLocaleDateString() else val
  valueOut: ->
    node = $(@context)
    if node.val() then new Date(node.val()) else null
