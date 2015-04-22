that = @
Template.registerHelper 'dynamicAttrs', () ->

  schema = AutoForm.find().ss._schema
  if !schema[@atts.name]?.optional and 'selected' not of @
    required = 'required'

  if 'value' of this
    name = @atts.name + '.' + @value
  else
    name = @atts.name

  tooltip =
    if 'value' of @
      value = @value
      options = schema[@atts.name]?.autoform.options or schema[@atts.name]?.autoform.afFieldInput.options
      option = _.find options, (option) ->
        option.value is value
      option?.tooltip
    else
      schema[@atts.name].autoform?.tooltip

  if tooltip
    'data-toggle': "tooltip"
    'data-content': tooltip
    'tooltip': true
    'class': 'tooltipped '+required
  else if required
    'class': required