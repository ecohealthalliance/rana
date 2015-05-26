Template.studies.helpers

  settings: () =>

    viewButton = (obj) ->
      studyPath = Router.path 'editStudy', {studyId: obj._id}
      """<a class="btn btn-primary btn-view" for="#{obj.name}" href="#{studyPath}">View</a>"""
    addReportButton = (obj) ->
      studiesPath = Router.path 'studies'
      addReportPath = Router.path 'newReport', {studyId: obj._id}, {query: "redirectOnSubmit=#{studiesPath}"}
      """<a class="btn btn-primary btn-add-report" for="#{obj.name}" href="#{addReportPath}">Add Report</a>"""
    removeButton = (obj) ->
      """<a class="btn btn-danger remove remove-form btn-remove" for="#{obj.name}" data-id="#{obj._id}">Remove</a>"""
    editButton = (obj) ->
      studiesPath = Router.path 'studies'
      editPath = Router.path 'editStudy', {studyId: obj._id}, {query: "redirectOnSubmit=#{studiesPath}"}
      """<a class="btn btn-edit btn-primary" for="#{obj.name}" href="#{editPath}">Edit</a>"""

    isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})?._id
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
          new Spacebars.SafeString(addReportButton(obj) + ' ' + editButton(obj) + ' ' + removeButton(obj))
        else if isAdmin
          if obj.dataUsePermissions == 'Share obfuscated'
            new Spacebars.SafeString(viewButton(obj) + ' ' + removeButton(obj))
          else
            new Spacebars.SafeString(addReportButton(obj) + ' ' + viewButton(obj) + ' ' + removeButton(obj))
        else if obj.dataUsePermissions == 'Share obfuscated'
          new Spacebars.SafeString(viewButton(obj))
        else
          new Spacebars.SafeString(addReportButton(obj) + ' ' + viewButton(obj))

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