Template.selectImportStudy.helpers

  settings: () =>

    selectReportButton = (obj) ->
      reportsPath = Router.path 'table'
      addReportPath = Router.path 'importReports', {studyId: obj._id}, {query: "redirectOnSubmit=#{reportsPath}"}
      """<a class="btn btn-success" href="#{addReportPath}">Import Reports</a>"""

    isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})?._id

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
        new Spacebars.SafeString(selectReportButton(obj))

    showColumnToggles: false
    fields: fields,
    noDataTmpl: Template.noStudies
