Template.form.reportDoc = ->
  # This session variable is used as a mechanism for setting
  # the form's content in code.
  # Currently it is used in the tests to fill out forms.
  Session.get("reportDoc")