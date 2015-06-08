Template.approvalBar.helpers

  approvalTooltip: =>
    if Template.currentData().report.approval is 'approved'
      "This report has been approved by GRRS administrators and is publicly viewable."
    else if Template.currentData().report.approval is 'pending'
      "This report is under review by GRRS administrators and is not yet publicly viewable."
    else if Template.currentData().report.approval is 'rejected'
      "This report has been rejected by GRRS administrators and is not publicly viewable."

  showApprovalControls: =>
    (Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id) and
    (Template.currentData().type == 'readonly' or Template.currentData().type == 'update')