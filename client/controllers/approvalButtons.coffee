Template.approvalButtons.helpers

  notPending: ->
    Template.parentData().report.approval != 'pending'

  notApproved: ->
    Template.parentData().report.approval != 'approved'

  notRejected: ->
    Template.parentData().report.approval != 'rejected'

  notUserPending: ->
    userId = Template.parentData().report.createdBy.userId
    Meteor.users.findOne({_id: userId}).approval != 'pending'

  notUserApproved: ->
    userId = Template.parentData().report.createdBy.userId
    Meteor.users.findOne({_id: userId}).approval != 'approved'

  notUserRejected: ->
    userId = Template.parentData().report.createdBy.userId
    Meteor.users.findOne({_id: userId}).approval != 'rejected'

Template.approvalButtons.events

  'click #approve-report': (e) =>
    @setApproval 'setReportApproval', Template.parentData().report._id, 'approved', "User approved", Template.parentData().redirectOnSubmit

  'click #reject-report': (e) =>
    @setApproval 'setReportApproval', Template.parentData().report._id, 'rejected', "User rejected", Template.parentData().redirectOnSubmit

  'click #pend-report': (e) =>
    @setApproval 'setReportApproval', Template.parentData().report._id, 'pending', "User made pending", Template.parentData().redirectOnSubmit

  'click #approve-user': (e) =>
    @setApproval 'setUserApproval', Template.parentData().report.createdBy.userId, 'approved', "User approved", Template.parentData().redirectOnSubmit

  'click #reject-user': (e) =>
    @setApproval 'setUserApproval', Template.parentData().report.createdBy.userId, 'rejected', "User rejected", Template.parentData().redirectOnSubmit

  'click #pend-user': (e) =>
    @setApproval 'setUserApproval', Template.parentData().report.createdBy.userId, 'pending', "User made pending", Template.parentData().redirectOnSubmit

@setApproval = (call, id, status, successMessage, template, redirect) ->

  Meteor.call call, id, status, (error, data) ->
    if error
      toastr.error(error.message)
    else
      toastr.options = {
        positionClass: "toast-bottom-center"
        timeOut: "3000"
      }
      toastr.success(successMessage)
      if redirect
        Router.go redirect
