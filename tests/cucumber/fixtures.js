(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function (reports) {
        collections.Reports.remove({});
        Meteor.users.remove({});
        Groups.remove({ path: { $ne: "rana" } });
        var adminUserId = Accounts.createUser({
          email: "admin@admin.com",
          password: "adminuser"
        });
        Roles.addUsersToRoles(
          adminUserId,
          ['admin', 'user'],
          Groups.findOne({path:"rana"})._id
        );
        var userId = Accounts.createUser({
          email: "test@test.com",
          password: "testuser"
        });
        _.each(reports, function (report) {
          report = _.extend({
            createdBy: {
              userId: userId,
              name: "Test User"
            }
          }, report);
          collections.Reports.insert(report);
        });
        return reports;
      },
      '/fixtures/addReports': function (reports) {
        var userId = Meteor.users.findOne({"emails.address": "test@test.com"})._id;
        _.each(reports, function (report) {
          report = _.extend({
            createdBy: {
              userId: userId,
              name: "Test User"
            }
          }, report);
          collections.Reports.insert(report);
        });
        return reports;
      }
    });

  }

})();
