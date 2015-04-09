getCollections = => @collections

Template.studyTable.helpers

  isEmpty: () =>
    not @collections.Studies.findOne()

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
            <a class="btn btn-primary" href="/study/#{obj._id}?redirectOnSubmit=/table">Edit</a>
            <a class="btn btn-danger remove remove-form" data-id="#{obj._id}">Remove</a>
          """)
        else
          new Spacebars.SafeString("""
            <a class="btn btn-primary" href="/study/#{obj._id}">View</a>
          """)

    showColumnToggles: true
    fields: fields

  Template.studyTable.events(
    'click .remove-form': (evt)->
      studyId = $(evt.target).data("id")
      reply = prompt('Type "delete" to confirm that this entire study and all associated reports should be removed.')
      if reply == "delete"
        Meteor.call 'removeStudyAndReports', studyId
  )