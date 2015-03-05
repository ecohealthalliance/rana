//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.visit = function (path, callback) {
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + path)
      .waitForExist(".container", function(err, exists){
        assert(!err);
        assert(exists, "Could not find container element");
      })
      .getText(".container", function(err, text){
        assert(!err);
        var regexString = "no route on the client or the server for url"
          .split(" ")
          .join("\\s+");
        assert(!RegExp(regexString, "i").test(text), "Missing page");
      }).call(callback);
    };
    this.Given('I am on the "$path" page', this.visit);
    this.When('I navigate to the "$path" page', this.visit);
    
    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      helper.world.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.When(/^I click submit$/, function (callback) {
      helper.world.browser
        .click('[type=submit]')
        .call(callback);
    });

    this.When('I click the "$buttonName" button',
    function (buttonName, callback) {
      var buttonNameToSelector = {
        "Columns" : ".reactive-table-columns-dropdown button"
      };
      var selector = buttonName;
      if(buttonName in buttonNameToSelector) {
        selector = buttonNameToSelector[buttonName];
      }
      helper.world.browser
        .click(selector)
        .call(callback);
    });

    this.Then(
      /^the database should( not)? have a report with the (name|email) "([^"]*)"$/,
    function (shouldNot, prop, value, callback) {
      var query = {};
      query[prop] = value;
      helper.world.browser
      .executeAsync(function(query, done){
        Meteor.subscribe("reports");
        Tracker.autorun(function(){
          var reports = collections.Reports.find(query);
          if(reports.count() > 0) done(reports.fetch());
        });
        window.setTimeout(done, 2000);
      }, query, _.once(function(err, ret){
        assert(!err);
        if(shouldNot) {
          assert(!ret.value, 'Report found');
        } else {
          assert.equal(ret.value.length, 1, 'Incorrect number of reports');
        }
      })).call(callback);
    });

    this.Given(/^there is a report( with a geopoint)? in the database$/,
    function(withGeo, callback) {
      helper.resetTestDB([{
        consent: true,
        dataUsePermissions: "Share full record",
        eventLocation: "25.046919772516173,121.55189514218364"
      }], function(err){
        if(err) {
          console.log(err);
        }
        assert(!err);
        helper.world.browser
        .executeAsync(function(done){
          Tracker.autorun(function(){
            var report = collections.Reports.findOne({
              eventLocation: {$exists: true}
            });
            if(report) done(report);
          });
          window.setTimeout(done, 2000);
        }, _.once(function(err, ret){
          assert(!err);
          assert(ret.value, "No reports in the database");
          callback();
        }));
      });
    });
    
    this.Given(/^there are no reports in the database$/,
    function (callback) {
      helper.resetTestDB([], callback);
    });

    this.Then("I should not see a checkbox for the edit column",
    function (callback) {
      helper.world.browser
        .waitForVisible('.leaflet-popup-content')
        .waitForVisible('.leaflet-popup-content', function(err, visible){
          assert(!err);
          assert(value);
        }).call(callback);
    });
    
    this.Then("I should not see a checkbox for the edit column",
    function (callback) {
      helper.world.browser
        .waitForVisible('.reactive-table-columns-dropdown .controls',
        function(err, visible){
          assert(!err);
          assert(!visible, "Controls column has visible checkbox.");
        }).call(callback);
    });
    
    this.Then('I should see the text "$text"',
    function (text, callback) {
      helper.world.browser
        .waitForText('body')
        .getText('body', function(err, bodyText){
          console.log(bodyText);
          assert(!err);
          assert(
            new RegExp(text, "i").test(bodyText),
            '"' + text + '" not in "' + bodyText + '"'
          );
        }).call(callback);
    });
    
  };

})();