# This code is based on the helpers code from autoform:
# https://github.com/aldeed/meteor-autoform/blob/9447f734f38c47ab47bdc8b630ec4575433ab23b/autoform-helpers.js
parseOptions = (options, helperName) ->
  hash = (options or {}).hash or {}
  # Find the autoform context
  afContext = AutoForm.find(helperName)
  # Call getDefs for side effect of throwing errors when name is not in schema
  hash.name and AutoForm.Utility.getDefs(afContext.ss, hash.name)
  _.extend {}, afContext, hash

Template.registerHelper 'afFieldLabelHTML', (options) ->
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
