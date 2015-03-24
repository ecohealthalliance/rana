getCollections = => @collections

# Based on bobince's regex escape function.
# source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
regexEscape = (s)->
  s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

generaHandler = _.throttle (e) ->
  generaValues = getCollections().Genera
    .find({
      value:
        $regex: "^" + regexEscape($(e.target).val())
        $options: "i"
    }, {
      limit: 5
    })
    .map((r)-> r.value)

  $("input[name='speciesGenus']").autocomplete
    source: generaValues
, 500

Template.genusAutocomplete_rana.events =
  "keyup": generaHandler
