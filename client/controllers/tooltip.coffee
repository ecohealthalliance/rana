@tooltipTexts =
  contactHeader: 'They must be willing to communicate about the case if so requested.'

Template.reportForm.rendered = () ->
  @$('[data-toggle="tooltip"]').popover({trigger: 'hover', placement: 'right auto', container: 'body'})

Template.studyForm.rendered = () ->
  @$('[data-toggle="tooltip"]').popover 
    trigger: 'hover'
    placement: 'right auto'
    container: 'body'
    viewport:
      selector: 'body'
      padding: 10

minorLabelBlockTexts =
  'eventLocation': 'Please provide the highest resolution data possible using (UTM or DD coordinates).'

Template.registerHelper 'minorLabelBlockText', (name) ->
  if name of minorLabelBlockTexts
    minorLabelBlockTexts[name]
  else
    false

Template.registerHelper 'tooltipText', (name) ->

  if name of tooltipTexts
    tooltipTexts[name]
