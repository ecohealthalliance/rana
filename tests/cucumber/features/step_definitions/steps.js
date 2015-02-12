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

    this.When(/^I fill out the form with the name "([^"]*)"$/, function (name, callback) {
      helper.world.browser
      .waitForExist(".form-group")
      .execute(function(){
        var generatedFormData = AutoForm.Fixtures.getData(collections.Reports.simpleSchema());
        generatedFormData['name'] = name;
        generatedFormData['email'] = "a@b.com";
        generatedFormData['institutionAddress']['postalCode'] = "12345";
        generatedFormData['images'] = [];
        generatedFormData['pathologyReports'] = [];
        Session.set("reportDoc", generatedFormData);
        // There is something wrong with the way collections work when testing
        // because this is returning null here, but it works in my browser.
        return collections.Reports.findOne(collections.Reports.insert(generatedFormData));
      }, function(err, ret){
        if(err) return callback.fail(err);
        console.log(ret);
      })
      .call(callback);
    });

    this.When(/^I click submit$/, function (callback) {
      helper.world.browser
        .click("[type=submit]")
        .call(callback);
    });

    this.Then(/^the database should have a report with the name "([^"]*)"$/, function (name, callback) {
      helper.world.browser
      .execute(function(){
        return collections.Reports.findOne({name: name});
      }, function(err, ret){
        console.log(ret);
        if(err) return callback.fail(err);
        if(ret.value == null) return callback.fail("Report not found");
      }).call(callback);
    });
  };

})();