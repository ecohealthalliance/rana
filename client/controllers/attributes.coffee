that = @
Template.registerHelper 'dynamicAttrs', () ->
  if !AutoForm.find().ss._schema[@atts.name].optional and 'selected' not of @
    required = 'required'

  if 'value' of this
    name = @atts.name + '.' + @value
  else
    name = @atts.name

  if name of that.tooltipTexts
    'data-toggle': "tooltip"
    'data-content': that.tooltipTexts[name]
    'tooltip': true
    'class': 'tooltipped '+required
  else if required
    'class': required