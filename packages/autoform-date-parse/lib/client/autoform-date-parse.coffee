AutoForm.addInputType 'date-parse',
  template: 'dateParse'
  valueIn: (val) ->
    if (val instanceof Date) then utils.toLocaleDateString(val) else val
  valueOut: ->
    node = $(@context)
    if node.val() then new Date(node.val()) else null

Template.dateParse.events

  'blur .form-control': (e,t) ->
    val = new Date(e.target.value)
    $(e.target).val utils.toLocaleDateString(val)
