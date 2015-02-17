//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  module.exports = function () {

    var helper = this;

    this.Given(/^I am on the "([^"]*)" page$/, function (path, callback) {
      helper.world.browser.
        url(helper.world.cucumber.mirror.rootUrl + path).
        call(callback);
    });

    this.When(/^I navigate to "([^"]*)"$/, function (relativePath, callback) {
      helper.world.browser.
        url(helper.world.cucumber.mirror.rootUrl + relativePath).
        call(callback);
    });

    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      helper.world.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.When(/^I fill out the form with the (name|email) "([^"]*)"$/, function (prop, value, callback) {
      helper.world.browser
      .waitForExist('.form-group')
      .execute(function(prop, value){
        var generatedFormData = AutoForm.Fixtures.getData(collections.Reports.simpleSchema());
        generatedFormData[prop] = value;
        generatedFormData['email'] = 'a@b.com';
        generatedFormData['institutionAddress']['postalCode'] = '12345';
        generatedFormData['images'] = [];
        generatedFormData['pathologyReports'] = [];
        generatedFormData['publicationInfo']['pdf'] = null;
        generatedFormData['eventLocation'] = null;
        var validationContext = collections
          .Reports
          .simpleSchema()
          .namedContext('test');
        if(!validationContext.validate(generatedFormData)) {
          return { error: validationContext.invalidKeys() };
        }
        Session.set('reportDoc', generatedFormData);
      }, prop, value, function(err, res){
        if(err) return callback.fail(err);
        if(res.value && res.value.error) {
          return callback.fail(JSON.stringify(res.value.error));
        }
        //console.log(res);
      })
      .call(callback);
    });

    this.When(/^I click submit$/, function (callback) {
      helper.world.browser
        .click('[type=submit]')
        .call(callback);
    });

    this.Then(
      /^the database should( not)? have a report with the (name|email) "([^"]*)"$/,
    function (shouldNot, prop, value, callback) {
      helper.world.browser
      .execute(function(prop, value){
        var query = {};
        query[prop] = value;
        return collections.Reports.findOne(query);
      }, prop, value, function(err, ret){
        if(err) return callback.fail(err);
        if(shouldNot) {
          if(ret.value !== null) return callback.fail('Report found');
        } else {
          if(ret.value === null) return callback.fail('Report not found');
        }
      }).call(callback);
    });
    
    this.When(/^I click on a report location marker$/, function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });
    
    this.Then(/^I should see a popup with information from the report$/, function (callback) {
      helper.world.browser
        .waitFor('.leaflet-popup-content')
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
              callback.fail("Missing Property: " + prop);
              break;
            }
          }
        })
        .call(callback);
    });
    
  };

})();