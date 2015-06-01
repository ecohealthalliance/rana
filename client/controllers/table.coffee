getCollections = => @collections

created = ->
  @query = new ReactiveVar()
Template.table.created = created
Template.pendingTable.created = created

query = ->
  Template.instance().query
Template.table.query = query
Template.pendingTable.query = query

filters = =>
  filters = []
  query = Template.instance().query?.get() or {}

  # reactive-table filters don't support arbitrary queries yet
  if ! _.isEmpty query
    queries = if '$and' of query then query['$and'] else [query]
    for q in queries
      key = Object.keys(q)[0]
      value = q[key] or ""
      filter = new ReactiveTable.Filter('reports-' + key, [key])
      if value isnt filter.get()
        filter.set(value)
      filters.push 'reports-' + key

  filters

Template.table.filters = filters
Template.pendingTable.filters = filters

Template.table.settings = () =>
  settings 'full'

Template.table.obfuscatedSettings = () =>
  settings 'obfuscated'

Template.pendingTable.settings = () =>
  settings 'pending'

settings = (tableType) =>

  isAdmin = Roles.userIsInRole Meteor.user(), "admin", Groups.findOne({path: 'rana'})._id
  schema = @collections.Reports.simpleSchema().schema()

  fields = []

  studyVars = {}
  getStudyNameVar = (studyId) ->
    if studyVars[studyId]
      return studyVars[studyId]
    else
      studyNameVar = new ReactiveVar("")
      studyVars[studyId] = studyNameVar
      onReady = () ->
        studyName = getCollections().Studies.findOne(studyId)?.name
        studyNameVar.set studyName
      Meteor.subscribe "studies", studyId, onReady
      return studyNameVar

  fields.push
    key: "studyId"
    label: "Study"
    fn: (val, obj) ->
      getStudyNameVar(val).get()

  if tableType in ['full', 'pending']
    fields.push
      key: "eventLocation"
      label: "Event Location"
      fn: (val, obj) ->
        if val
          String(val.geo.coordinates[0]) + ', ' + String(val.geo.coordinates[1])
        else
          ''
  else
    fields.push
      key: "eventLocation.country"
      label: "Event Location Country"

  if tableType in ['full', 'pending']
    columns = [
      "speciesGenus"
      "speciesName"
      "screeningReason"
      "populationType"
    ]
    for key in columns
      do (key) ->
        label = schema[key].label or key
        if label.length > 30
          label = key
        fields.push
          key: key
          label: label
          fn: (val, object) ->
            if schema[key]?.autoform?.afFieldInput?.options
              option = _.findWhere(
                schema[key].autoform.afFieldInput.options,
                value: val
              )
              display = option?.label or ''
              new Spacebars.SafeString("<span sort=#{sort}>#{display}</span>")
            else
              output = val or ''

              # capitalize first letter
              if output.length > 1
                output = output.charAt(0).toUpperCase() + output.slice(1)

              # truncate long fields
              if output.length > 100
                output = output.slice(0, 100) + '...'

              # put empty values at the end
              if output is '' then sort = 2 else sort = 1

              if not output
                output = ''

              # use option labels instead of values
              new Spacebars.SafeString("<span sort=#{sort}>#{output}</span>")

  fields.push
    key: "createdBy.name"
    label: "Submitted by"

  fields.push
    key: "controls"
    label: ""
    hideToggle: true
    fn: (val, obj) ->
      if obj.createdBy.userId == Meteor.userId()
        tablePath = Router.path 'table'
        editPath = Router.path 'editReport', {reportId: obj._id}, {query: "redirectOnSubmit=#{tablePath}"}
        new Spacebars.SafeString("""
          <a class="control edit" href="#{editPath}" title="Edit"></a>
          <a class="control remove remove-form" data-id="#{obj._id}" title="Remove"></a>
        """)
      else if isAdmin
        viewPath = Router.path 'editReport', {reportId: obj._id}
        new Spacebars.SafeString("""
          <a class="control view" href="#{viewPath}" title="View"></a>
          <a class="control remove remove-form" data-id="#{obj._id}" title="Remove"></a>
        """)
      else
        viewPath = Router.path 'editReport', {reportId: obj._id}
        new Spacebars.SafeString("""
          <a class="control view" href="#{viewPath}" title="View"></a>
        """)

  if tableType is 'pending'
    fields.push
      key: "controls"
      label: ""
      hideToggle: true
      fn: (val, obj) ->
        new Spacebars.SafeString("""
          <a class="control approve-report"  data-id="#{obj._id}" title="Approve report"></a>
          <a class="control approve-user" data-id="#{obj.createdBy.userId}" title="Approve User"></a>
          <a class="control reject-report" data-id="#{obj._id}" title="Reject Report"></a>
        """)

  if tableType is 'pending'
    noDataTmpl = Template.noPendingReports
  else
    noDataTmpl = Template.noReports

  showColumnToggles: true
  showFilter: false
  fields: fields
  noDataTmpl: noDataTmpl
  rowClass: (val) ->
    if !isAdmin
      status = val.approval
      switch status
        when 'approved' then 'approved'
        when 'rejected' then 'rejected'
        when 'pending' then 'pending'

events =
  'click .remove-form': (evt)->
    reportId = $(evt.target).data("id")
    reply = prompt('Type "delete" to confirm that this report should be removed.')
    if reply == "delete"
      getCollections().Reports.remove(reportId)

  'click .toggle-filter': () ->
    $('.filter-controls').toggleClass('hidden')
    $('.toggle-filter').toggleClass('showingOpts')
  "click .next-page, click .previous-page" : () ->
    if (window.scrollY > 0)
      $('body').animate({scrollTop:0,400})

  'click .export:not(.disabled)': (event, template) ->
    $(event.target).addClass('disabled')
    query = template.query.get()
    Meteor.call 'export', query, (err, result) ->
      if (err)
        console.log err
        alert "There was an error exporting the data."
      else
        window.open "data:text/csv;charset=utf-8," + encodeURIComponent(result)
      $(event.target).removeClass('disabled')

Template.table.events events
Template.pendingTable.events events

Template.pendingTable.events

  'click .approve-report': (e) ->
    Meteor.call 'setReportApproval', $(e.target).data('id'), 'approved'
    toastr.options = {
      positionClass: "toast-bottom-center"
      timeOut: "3000"
    }
    toastr.success("""Report approved""")

  'click .approve-user': (e) ->
    Meteor.call 'setUserApproval', $(e.target).data('id'), 'approved'
    toastr.options = {
      positionClass: "toast-bottom-center"
      timeOut: "3000"
    }
    toastr.success("""User and all pending reports approved""")

  'click .reject-report': (e) ->
    Meteor.call 'setReportApproval', $(e.target).data('id'), 'rejected'
    toastr.options = {
      positionClass: "toast-bottom-center"
      timeOut: "3000"
    }
    toastr.success("""Report rejected""")

