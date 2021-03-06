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
      toastr.remove()
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
      toastr.remove()
      errorLocation = $("""[data-schema-key="#{error.invalidKeys[0].name}"]""")
        .parent()
        .offset()
        ?.top
      window.scrollTo(0, errorLocation) if errorLocation
      toastr.options = {
        closeButton: true
        positionClass: "toast-bottom-center"
        timeOut: "100000"
        extendedTimeOut: "100000"
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

showApprovalBar = ->
  (Template.currentData().type in ['update', 'disabled']) and
  ((Meteor.userId() == Template.currentData().report.createdBy.userId) or
   (Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id))


Template.reportFormComplete.helpers
  isInsert: ->
    Template.currentData().type == 'insert'

  isUpdate: ->
    Template.currentData().type == 'update'

  showApprovalBar: showApprovalBar

  studyId: ->
    studyId: @study._id

  userApproval: ->
    Meteor.user().approval

Template.reportFormObfuscated.helpers

  showApprovalBar: showApprovalBar

  studyId: ->
    studyId: @study._id

Template.reportFormComplete.events

  'click .review-panel-header': (e)->
    $(e.target).toggleClass('showing')
    $('.review-content').toggleClass('hidden-panel')
    $('.page-wrap').toggleClass('curtain')

  'keypress': (e, t) ->
    # stop "enter" press from triggering map geolocation
    if e.which is 13
      e.preventDefault()


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
    $($('.leaflet-container')[0]).data('map').invalidateSize()
    @$('[data-toggle="popover"]').popover popoverOpts
  setTimeout reset, 0

Template.reportFormObfuscated.created = () ->
  reset = () ->
    @$('[data-toggle="popover"]').popover popoverOpts
  setTimeout reset, 0
