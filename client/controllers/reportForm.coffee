getCollections = => @collections
contactFromUser = @contactFromUser

AutoForm.addHooks(
  'ranavirus-report', {
    formToDoc: (doc)->
      doc.createdBy = {
        userId: Meteor.userId()
        name: Meteor.user().profile?.name or "None"
      }
      return doc
    onSuccess: (operation, result, template)->
      toastr.options = {
        closeButton: true
        positionClass: "toast-bottom-center"
        timeOut: "100000"
        # This is the timeout after a mouseover event
        extendedTimeOut: "100000"
      }
      editPath = Router.path 'editReport', {reportId: @docId}
      toastr.success("""
      <div>#{operation} successful!</div>
      <a href="#{editPath}">Edit Report</a>
      """)
      window.scrollTo(0, 0)
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit
      else
        window.scrollTo(0, 0)
        $('#ranavirus-report').show()

    onError: (operation, error) ->
      errorLocation = $("""[data-schema-key="#{error.invalidKeys[0].name}"]""")
        .parent()
        .offset()
        ?.top
      window.scrollTo(0, errorLocation) if errorLocation
      toastr.options = {
        closeButton: true
        positionClass: "toast-bottom-center"
      }
      toastr.error(error.message)
  }
)

Template.registerHelper 'reportDoc', () =>
  if Template.currentData().report
      Template.currentData().report
    else
      study = _.extend Template.currentData().study, { studyId: Template.currentData().study._id }
      contactFromUser = @contactFromUser()
      @mergeObjects study.contact, contactFromUser
      study

Template.reportFormComplete.helpers
  isInsert: ->
    Template.currentData().type == 'insert'

  isUpdate: ->
    Template.currentData().type == 'update'

  studyId: ->
    studyId: @study._id

  userApproval: ->
    Meteor.user().approval

  isOwner: ->
    ( (Meteor.userId() == Template.currentData().report.createdBy.userId) and not
      (Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id) )

  isPending: ->
    # console.log 'currentData', Template.currentData()
    ( (Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id) and
      (Template.currentData().report.approval == 'pending') )

Template.reportFormObfuscated.helpers
  studyId: ->
    studyId: @study._id

Template.reportFormComplete.events

  'click .review-panel-header': (e)->
    $(e.target).toggleClass('showing')
    $('.review-content').toggleClass('hidden-panel')
    $('.page-wrap').toggleClass('curtain')

  'click #approve-report': (e) ->
    if Meteor.call 'setReportApproval', Template.currentData().report._id, 'approved'
      toastr.options = {
        positionClass: "toast-bottom-center"
        timeOut: "5"
      }
      toastr.success("""Report approved""")
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit

  'click #approve-user': (e) ->
    if Meteor.call 'setUserApproval', Template.currentData().report.createdBy.userId, 'approved'
      toastr.success("""User and all pending reports approved""")
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit

  'click #reject-report': (e) ->
    if Meteor.call 'setReportApproval', Template.currentData().report._id, 'rejected'
      toastr.success("""Report rejected""")
      if template.data.redirectOnSubmit
        Router.go template.data.redirectOnSubmit


popoverOpts =
  trigger: 'hover'
  placement: 'bottom auto'
  container: 'body'
  viewport:
    selector: 'body'
    padding: 10
  animation: true
  delay:
    show: 350
    hide: 100

Template.reportFormComplete.created = () ->
  $('#ranavirus-report').hide()
  reset = () ->
    AutoForm.resetForm('ranavirus-report')
    $('#ranavirus-report').show()
    @$('[data-toggle="popover"]').popover popoverOpts
  setTimeout reset, 0
