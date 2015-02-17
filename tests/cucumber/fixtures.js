(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function () {
        collections.Reports.remove({});
        _.each([{
          consent: true,
          dataUsePermissions: "Share full record",
          email: "test@test.com",
          eventLocation: "25.046919772516173,121.55189514218364",
          name: "Mock data",
          phone: "12345"
        }], function (report) {
          collections.Reports.insert(report);
        });
      }
    });

  }

})();
