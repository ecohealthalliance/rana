(function () {

  'use strict';

  var assert = require('assert');

  module.exports = function () {

    var helper = this;

    var _ = Package["underscore"]._;
    var path = require('path');

    this.getAppDirectory = function () {
      var outPath = process.cwd();
      while(path.basename(outPath) !== ".meteor") {
        assert(outPath.length > 1);
        outPath = path.join(outPath, '..');
      }
      return path.join(outPath, '..');
    };

    this.World = function (next) {

      helper.world = this;

      helper.world.cucumber = Package['xolvio:cucumber'].cucumber;
      
      Package['xolvio:webdriver'].wdio.getGhostDriver(function (browser) {
        helper.world.browser = browser;

        browser.addCommand("mustExist", function(selector, callback){
          browser.waitForExist(selector, function(err, exists){
            assert.equal(err, null);
            assert(exists, "Could not find " + selector);
          }).call(callback);
        });

        // see:
        // https://github.com/ecohealthalliance/rana/issues/61
        browser.addCommand("uploadFileByPath", function(selector, filepath, callback){
          browser.requestHandler.create(
            '/session/:sessionId/file',
            {
              selector: selector,
              filepath: filepath
            },
            function(err, res) {
              console.log(err, res);
              browser.pause(2000).call(callback);
            }
          );
        });

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
        browser.call(next);
      });

    }; 

  };

})();