//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.Given(/^I am on the "([^"]*)" page$/, function (path, callback) {
      helper.world.browser.
        url(helper.world.cucumber.mirror.rootUrl + path).
        call(callback);
    });

    this.When(/^I navigate to "([^"]*)"$/, function (path, callback) {
      helper.world.browser.
        url(helper.world.cucumber.mirror.rootUrl + path).
        call(callback);
    });

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
      console.log(prop, value);
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
        console.log(ret);
        if(err) return callback.fail(err);
        if(ret.value && ret.value.length === 1) {
          if(shouldNot) return callback.fail('Report found');
        } else {
          if(!shouldNot) return callback.fail('Report not found');
        }
        callback();
      }));
    });
    
    this.When(/^I click on a report location marker$/, function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });
    
    this.Then(/^I should see a popup with information from the report$/, function (callback) {
      helper.world.browser
        .getText('.leaflet-popup-content', function(err, value){
          if(err) return callback.fail(err);
          var props = [
            'date',
            'type of population',
            'vertebrate classes',
            'species affected name',
            'number of individuals involved'
          ];
          for(var i=0;i<props.length;i++) {
            var prop = props[i];
            if(!RegExp(prop, "i").test(value)) {
              return callback.fail("Missing Property: " + prop);
            }
          }
          callback();
        });
    });
    
    this.Given(/^there is a report with a geopoint in the database$/, function (callback) {
      return callback();
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
        if(err) return callback.fail(err);
        if(!ret.value) return callback.fail("No reports with a geopoint in the database");
        callback();
      }));
    });
    
  };

})();