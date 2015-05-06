window.utils =
  # Based on bobince's regex escape function.
  # source: http://stackoverflow.com/questions/3561493/is-there-a-regexp-escape-function-in-javascript/3561711#3561711
  regexEscape: (s)->
    s.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
