Template.studies.helpers

  settings: () =>
    schema = @collections.Studies.simpleSchema().schema()

    fields = [
        key: "name"
        label: "Name"
      ,
        key: "createdBy.name"
        label: "Submitted by"
    ]

    fields.push
      key: "controls"
      label: ""
      hideToggle: true
      fn: (val, obj) ->
        if obj.createdBy.userId == Meteor.userId()
          new Spacebars.SafeString("""
            <a class="btn btn-primary btn-edit" for="#{obj.name}" href="/study/#{obj._id}?redirectOnSubmit=/studies">Edit</a>
            <a class="btn btn-danger remove remove-form" data-id="#{obj._id}">Remove</a>
          """)
        else
          new Spacebars.SafeString("""
            <a class="btn btn-primary" href="/study/#{obj._id}">View</a>
          """)

    showColumnToggles: true
    fields: fields,
    noDataTmpl: Template.noStudies

  Template.studies.events(
    'click .remove-form': (evt)->
      studyId = $(evt.target).data("id")
      reply = prompt('Type "delete" to confirm that this entire study and all associated reports should be removed.')
      if reply == "delete"
        Meteor.call 'removeStudyAndReports', studyId
  )