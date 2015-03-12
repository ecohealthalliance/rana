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
      
      var options = {
        host: 'localhost',
        port: 4444,
        desiredCapabilities: {
          browserName: 'chrome'
        }
      };
      
      Package['xolvio:webdriver'].wdio.getChromeDriverRemote(options, function (browser) {
        helper.world.browser = browser;

        browser.addCommand("mustExist", function(selector, callback){
          browser.waitForExist(selector, function(err, exists){
            assert.ifError(err);
            assert(exists, "Could not find " + selector);
          }).call(callback);
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
        
        browser.addCommand("getTextWhenVisible", function(selector, callback) {
          browser
          .waitForText(selector, function(err, exists){
            assert.ifError(err);
            assert(exists, "Text does not exist");
          })
          .getText(selector, callback);
        });
        
        browser.addCommand("clickWhenVisible", function(selector, callback) {
          browser
          .waitForExist(selector, 1000, function(err, exists){
            assert.ifError(err);
            assert(exists, selector + " does not exist");
          })
          .click(selector, callback);
        });
        
        browser.call(next);
      });

    }; 

  };

})();