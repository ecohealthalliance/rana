(function () {

  'use strict';

  if (Meteor.isServer) {

    Meteor.methods({
      '/fixtures/resetDB': function (reports) {
        collections.Reports.remove({});
        _.each(reports, function (report) {
          collections.Reports.insert(report);
        });
      }
    });

  }

})();
