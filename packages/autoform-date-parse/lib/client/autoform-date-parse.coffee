AutoForm.addInputType 'date-parse',
  template: 'dateParse'
  valueIn: (val) ->
    if (val instanceof Date) then moment(val).format("MM/DD/YYYY") else val
  valueOut: ->
    node = $(@context)
    if node.val() then moment(node.val(), "MM/DD/YYYY").toDate() else null

Template.dateParse.events

  'blur .form-control': (e,t) ->
    val = moment(e.target.value)
    $(e.target).val val.format("MM/DD/YYYY")
