Template.studies.helpers

  settings: () =>

    viewButton = (obj) ->
      studyPath = Router.path 'editStudy', {studyId: obj._id}
      """<a class="control view btn-view" for="#{obj.name}" href="study/#{obj._id}" title="View"></a>"""
    addReportButton = (obj) ->
      studiesPath = Router.path 'studies'
      addReportPath = Router.path 'newReport', {studyId: obj._id}, {query: "redirectOnSubmit=#{studiesPath}"}
      """<a class="control btn-add-report" for="#{obj.name}" href="study/#{obj._id}/report?redirectOnSubmit=/studies" title="Add Report"></a>"""
    removeButton = (obj) ->
      """<a class="control remove remove-form btn-remove" for="#{obj.name}" data-id="#{obj._id}" title="Remove"></a>"""
    editButton = (obj) ->
      studiesPath = Router.path 'studies'
      editPath = Router.path 'editStudy', {studyId: obj._id}, {query: "redirectOnSubmit=#{studiesPath}"}
      """<a class="control btn-edit" for="#{obj.name}" href="study/#{obj._id}?redirectOnSubmit=/studies" title="Edit"></a>"""

    isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})._id
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