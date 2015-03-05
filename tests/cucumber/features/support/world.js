(function () {

  'use strict';

  var assert = require('assert');

  module.exports = function () {

    var helper = this;

    var _ = Package["underscore"]._;

    this.World = function (next) {

      helper.world = this;

      helper.world.cucumber = Package['xolvio:cucumber'].cucumber;
      
      Package['xolvio:webdriver'].wdio.getGhostDriver(function (browser) {
        helper.world.browser = browser;

        browser.addCommand("getMyReports", function(baseQuery, callback) {
          browser
          .timeoutsAsyncScript(2000)
          .executeAsync(function(baseQuery, done){
            Meteor.subscribe("reports");
            Tracker.autorun(function(){
              var query = _.extend(baseQuery, {
                'createdBy.userId': Meteor.userId()
              });
              var reports = collections.Reports.find(query);
              if(reports.count() > 0) done(reports.fetch());
            });
            window.setTimeout(done, 2000);
          }, baseQuery, _.once(callback));
        });
        
        browser.addCommand("getTextWhenVisible", function(selector, callback) {
          browser
          .waitForText(selector, function(err, exists){
            assert.equal(err, null);
            assert(exists, "Text does not exist");
          })
          .getText(selector, callback);
        });
        
        browser.call(next);
      });

    }; 

  };

})();