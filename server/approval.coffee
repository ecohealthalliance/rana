Meteor.methods

  setReportApproval: (reportId, approval) ->
    if Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id
      collections.Reports.update {_id: reportId}, {$set: {approval: approval}}

  setUserApproval: (userId, approval) ->
    if Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id
      Meteor.users.update {_id: userId}, {$set: {approval: approval}}
      collections.Reports.update {'createdBy.userId': userId, approval: 'pending'}, {$set: {approval: approval}}, {multi:true}
