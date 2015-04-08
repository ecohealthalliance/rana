window.utils =
  # Based on bobince's regex escape function.
  # source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
  regexEscape: (s)->
    s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

  subscribeToDocFiles: (doc) ->
    ids = (doc?.pathologyReports or []).map((rObj)-> rObj.report)
    ids = ids.concat(
      (doc?.images or []).map((iObj)-> iObj.image)
    )
    Meteor.subscribe("files", ids)
    if doc?.publicationInfo?.pdf
      Meteor.subscribe(
        "pdfs",
        doc.publicationInfo.pdf
      )
