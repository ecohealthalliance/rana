@tooltipTexts =
  contactHeader: 'They must be willing to communicate about the case if so requested.'

popoverOpts =
  trigger: 'hover'
  placement: 'bottom auto'
  container: 'body'
  viewport:
    selector: 'body'
    padding: 10
  animation: true
  delay:
    show: 350
    hide: 100

Template.reportForm.rendered = () ->
  @$('[data-toggle="popover"]').popover popoverOpts

Template.studyForm.rendered = () ->
  @$('[data-toggle="popover"]').popover popoverOpts


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
