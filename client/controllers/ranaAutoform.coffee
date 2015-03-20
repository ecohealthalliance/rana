# Derived from the original JS version here.
# https://github.com/aldeed/meteor-autoform/blob/9568b4ada1035e3b18d713f9d7c0c27083fe98a0/templates/bootstrap3/bootstrap3.js
# We took the relevant helpers from the bootstrap3 template, converted them to
# CoffeeScript and customized them for the custom rana AutoForm templates.
# If you need to implement a helper for a new input type, check that .js
# file first to see if has already been done in the bootstrap3 template.
#
# In the future we may want to use extension lib this:
# https://github.com/aldeed/meteor-template-extension

_.each [
    'afSelect_rana',
    'afTextarea_rana',
    'afInputText_rana',
    'afInputDate_rana',
    'afInputNumber_rana',
    'afInputEmail_rana',
    'afInputTel_rana',
    'genusAutocomplete_rana'
  ], (tmplName) ->
    Template[tmplName].helpers
      atts: () ->
        atts = _.clone @atts
        AutoForm.Utility.addClass atts, 'form-control'

Template['afFormGroup_rana'].helpers

  skipLabel: () ->
    type = AutoForm.getInputType @afFieldInputAtts
    @skipLabel || type == 'boolean-checkbox'

_.each [
    'afCheckboxGroup_rana',
    'afRadioGroup_rana'
  ], (tmplName) ->
    Template[tmplName].helpers

      atts: () ->
        atts = _.clone this.atts
        if (@selected)
          atts.checked = ''
        delete atts['data-schema-key']
        atts

      dsk: () ->
        { 'data-schema-key': @atts['data-schema-key'] }

Template['afSelect_rana'].helpers
  optionAtts: () ->
    atts = { value: @value }
    if (@selected)
      atts.selected = ''
    atts

Template['afBooleanRadioGroup_rana'].helpers

  falseAtts: () ->
    atts = _.omit this.atts, 'trueLabel', 'falseLabel', 'data-schema-key'
    if @value is false
      atts.checked = ''
    atts

  trueAtts: () ->
    atts = _.omit(this.atts, 'trueLabel', 'falseLabel', 'data-schema-key');
    if @value is true
      atts.checked = ''
    atts

  dsk: () ->
    { 'data-schema-key': this.atts['data-schema-key'] }
