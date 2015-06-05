Template.approvalBar.helpers

  approvalTooltip: =>
    if Template.currentData().report.approval is 'approved'
      "This report has been approved by GRRS administrators and is publicly viewable."
    else if Template.currentData().report.approval is 'pending'
      "This report is under review by GRRS administrators and is not yet publicly viewable."
    else if Template.currentData().report.approval is 'rejected'
      "This report has been rejected by GRRS administrators and is not publicly viewable."
