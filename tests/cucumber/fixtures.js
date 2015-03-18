(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function (reports) {
        collections.Reports.remove({});
        Meteor.users.remove({});
        var userId = Accounts.createUser({
          email: "test@test.com",
          password: "testuser",
          profile: {
            organization : "EHA",
            organizationStreet : "460 West 34th Street – 17th floor",
            organizationCity: "New York",
            organizationStateOrProvince: "NY",
            organizationCountry: "USA",
            organizationPostalCode : "10001"
          }
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

        collections.Studies.remove({});
        collections.Studies.insert({
          '_id': 'fakeid',
          'name': 'Test Study',
          'dataUsePermissions': 'Share full record',
          'consent': true,
          'csvFile': 'fakefile',
          'contact': {
            'name': 'Test User',
            'email': 'test@test.com'
          },
          createdBy: {
              userId: userId,
              name: "Test User"
            }
        });
        return reports;
      }
    });

  }

})();
