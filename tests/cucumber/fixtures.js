(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function (reports) {
        collections.Reports.remove({});
        Meteor.users.remove({});
        _.each(reports, function (report) {
          collections.Reports.insert(report);
        });
        Accounts.createUser({
          email: "test@test.com",
          password: "testuser"
        });
      }
    });

  }

})();
