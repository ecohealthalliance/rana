regHelper = Template.registerHelper

parseOptions = (options, helperName) ->
  hash = (options or {}).hash or {}
  # Find the autoform context
  afContext = AutoForm.find(helperName)
  # Call getDefs for side effect of throwing errors when name is not in schema
  hash.name and AutoForm.Utility.getDefs(afContext.ss, hash.name)
  _.extend {}, afContext, hash

if typeof regHelper != 'function'
  regHelper = UI.registerHelper

regHelper 'afFieldLabelHTML', (options) ->
  options = parseOptions(options, 'afFieldLabelText')
  if SimpleSchema._makeGeneric(options.name).slice(-1) == '$'
    # for array items we don't want to inflect the label because
    # we will end up with a number
    label = options.ss.label(options.name)
    if !isNaN(parseInt(label, 10))
      null
    else
      Spacebars.SafeString(label)
  else
    Spacebars.SafeString(options.ss.label options.name)
