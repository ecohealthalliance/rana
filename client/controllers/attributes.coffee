Template.registerHelper 'dynamicAttrs', () ->
  schema = AutoForm.getFormSchema() #AutoForm.find().ss._schema
  if not schema or not @atts?.name then return @atts
  
  name = @atts.name #.replace(/\.[\d+]\./, ".$.")
  if !schema[name]?.optional and 'selected' not of @
    required = 'required'

  

  tooltip =
    if @value
      value = @value
      options = schema[name]?.autoform.options or schema[name]?.autoform.afFieldInput.options
      option = _.find options, (option) ->
        option.value is value
      option?.tooltip
    else
      schema[name].autoform?.tooltip

  if tooltip
    'data-toggle': "popover"
    'data-content': tooltip
    'tooltip': true
    'class': 'tooltipped '+required
  else if required
    'class': required