that = @
Template.registerHelper 'dynamicAttrs', () ->
  if !AutoForm.find().ss._schema[@atts.name].optional
    required = 'required'

  console.log that.tooltipTexts

  if 'value' of this
    name = @atts.name + '.' + @value
  else
    name = @atts.name

  if name of that.tooltipTexts
    'data-toggle': "tooltip"
    'data-placement': "right"
    'title': that.tooltipTexts[name]
    'class': 'tooltipped '+required
  else
    'class': required