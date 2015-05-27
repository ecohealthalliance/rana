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
        __SpeciesCollection.remove({});
        __SpeciesCollection.insert({
          "genera" : [  "Lithobates" ],
          "primaryName" : "Lithobates sylvaticus",
          "synonyms" : [
            "Лесная лягушка",
            "L. sylvaticus",
            "Rana sylvatica",
            "Żaba leśna",
            "Grenouille des bois",
            "Wood frog",
            "Lithobates sylvaticus",
            "Boskikker",
            "Waldfrosch"
          ],
          "lowerCaseSynonyms" : [
            "лесная лягушка",
            "l. sylvaticus",
            "rana sylvatica",
            "żaba leśna",
            "grenouille des bois",
            "wood frog",
            "lithobates sylvaticus",
            "boskikker",
            "waldfrosch"
          ],
          "entity" : "http://dbpedia.org/resource/Wood_frog"
        });
        Roles.addUsersToRoles(
          adminUserId,
          ['admin', 'user'],
          Groups.findOne({path:"rana"})._id
        );
        var userId = Accounts.createUser({
          email: "test@test.com",
          password: "testuser",
          profile: {
            name: "Test User",
            organization : "EHA",
            organizationStreet : "460 West 34th Street – 17th floor",
            organizationCity: "New York",
            organizationStateOrProvince: "NY",
            organizationCountry: "USA",
            organizationPostalCode : "10001"
          }
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
      },
      '/fixtures/addReports': function (reports) {
        var userId = Meteor.users.findOne({"emails.address": "test@test.com"})._id;
        _.each(reports, function (report) {
          report = _.extend({
            dataUsePermissions: 'Share full record',
            consent: true,
            createdBy: {
              userId: userId,
              name: "Test User"
            },
            studyId: "fakeid",
            contact: {
              name: 'Test User',
              email: 'test@test.com'
            }
          }, report);
          collections.Reports.insert(report);
        });
        return reports;
      },

      '/fixtures/addStudies': function (studies) {
        collections.Studies.remove({});
        var userId = Meteor.users.findOne({"emails.address": "test@test.com"})._id;
        _.each(studies, function (study) {
          study = _.extend({
            name: "Test Study " + _.uniqueId(),
            publicationInfo: {
              dataPublished: false
            },
            dataUsePermissions: 'Share full record',
            consent: true,
            createdBy: {
              userId: userId,
              name: "Test User"
            },
            contact: {
              name: 'Test User',
              email: 'test@test.com'
            }
          }, study);
          collections.Studies.insert(study);
        });
        return studies;
      },

      '/fixtures/checkForReports': function (reportQuery) {
        return collections.Reports.find(reportQuery).fetch();
      },

      '/fixtures/checkForStudies': function (studyQuery) {
        return collections.Studies.find(studyQuery).fetch();
      }
    });

  }

})();
