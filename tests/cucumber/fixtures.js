(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function (reports) {
        collections.Reports.remove({});
        Meteor.users.remove({});
        Groups.remove({});
        var userId = Accounts.createUser({
          email: "test@test.com",
          password: "testuser"
        });
        _.each(reports, function (report) {
          report = _.extend(report, {
            createdBy: {
              userId: userId,
              name: "Test User"
            }
          });
          collections.Reports.insert(report);
        });
        var adminUserId = Accounts.createUser({
          email: "admin@admin.com",
          password: "adminuser"
        });
        // Currently doesn't work:
        // Groups.remove({});
        // var groupId = Groups.insert({
        //   name: "testgroup",
        //   path: "testgroup",
        //   description: "testgroup"
        // });
        // Roles.addUsersToRoles(adminUserId, ['admin', 'user'], "test")
        return reports;
      }
    });

  }

})();
