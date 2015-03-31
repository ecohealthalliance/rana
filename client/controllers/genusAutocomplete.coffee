getCollections = => @collections

generaHandler = _.throttle (e) ->
  generaValues = getCollections().Genera
    .find({
      value:
        $regex: "^" + utils.regexEscape($(e.target).val())
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
