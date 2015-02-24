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
    this.When('I navigate to "$path"', this.visit);
    
    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      helper.world.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.When(
      /^I fill out the form with the (name|email) "([^"]*)"$/,
    function (prop, value, callback) {
      helper.world.browser
      .waitForExist('.form-group')
      .execute(function(prop, value){
        var generatedFormData = AutoForm.Fixtures.getData(collections.Reports.simpleSchema());
        generatedFormData['email'] = 'a@b.com';
        generatedFormData['institutionAddress']['postalCode'] = '12345';
        generatedFormData['images'] = [];
        generatedFormData['pathologyReports'] = [];
        generatedFormData['publicationInfo']['pdf'] = null;
        generatedFormData['eventLocation'] = null;
        //These are needed to make sure the form is visible:
        generatedFormData['consent'] = true;
        generatedFormData['dataUsePermissions'] = 'Share full record';
        generatedFormData[prop] = value;
        Session.set('reportDoc', generatedFormData);
      }, prop, value, function(err, res){
        if(err) {
          return callback.fail(err);
        } else {
          callback();
        }
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

    this.Then(/^the webpage should( not)? display a validation error$/,
    function(shouldNot, callback){
      helper.world.browser
      .isExisting('.has-error', function(err, exists){
        if(err) return callback.fail(err);
        if(!shouldNot && !exists) return callback.fail("Missing validation error");
        if(shouldNot && exists) return callback.fail("Validation error");
        callback();
      });
    });

    this.Then(
      /^the database should( not)? have a report with the (name|email) "([^"]*)"$/,
    function (shouldNot, prop, value, callback) {
      helper.world.browser
      .executeAsync(function(prop, value, done){
        var query = {};
        query[prop] = value;
        Meteor.subscribe("reports");
        Tracker.autorun(function(){
          var reports = collections.Reports.find(query);
          if(reports.count() > 0) done(reports.fetch());
        });
        window.setTimeout(done, 2000);
      }, prop, value, _.once(function(err, ret){
        if(err) return callback.fail(err);
        if(ret.value && ret.value.length === 1) {
          if(shouldNot) return callback.fail('Report found');
        } else {
          if(!shouldNot) return callback.fail('Report not found');
        }
        callback();
      }));
    });
    
    this.When(/^I click on a report location marker$/,
    function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });
    
    this.Then(/^I should see a popup with information from the report$/,
    function (callback) {
      helper.world.browser
        .getText('.leaflet-popup-content', function(err, value){
          assert(!err);
          var props = [
            'date',
            'type of population',
            'vertebrate classes',
            'species affected name',
            'number of individuals involved'
          ];
          for(var i=0;i<props.length;i++) {
            var prop = props[i];
            assert(RegExp(prop, "i").test(value), "Missing Property: " + prop);
          }
        }).call(callback);
    });

    this.Given(/^there is a report( with a geopoint)? in the database$/,
    function(withGeo, callback) {
      helper.resetTestDB([{
        consent: true,
        dataUsePermissions: "Share full record",
        email: "test@test.com",
        eventLocation: "25.046919772516173,121.55189514218364",
        name: "Mock data",
        phone: "12345"
      }], function(){
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
          assert(ret.value, "No reports with a geopoint in the database");
          callback();
        }));
      });
    });
    
    this.Given(/^there are no reports in the database$/,
    function (callback) {
      helper.resetTestDB([], callback);
    });
    
  };

})();