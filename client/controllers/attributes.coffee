Template.registerHelper 'dynamicAttrs', () ->
  if !AutoForm.find().ss._schema[@atts.name].optional
    required = 'required'

  if 'value' of this
    name = @atts.name + '.' + @value
  else
    name = @atts.name

  if name of @tooltipTexts
    'data-toggle': "tooltip"
    'data-placement': "right"
    'title': @tooltipTexts[name]
    'class': 'tooltipped '+required
  else
    'class': required