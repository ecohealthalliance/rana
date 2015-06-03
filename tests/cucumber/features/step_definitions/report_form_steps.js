//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');
  var _ = require('underscore');

  var fillInReportForm = function (context, customValues, callback) {
    var defaultValues = {};
    defaultValues['studyId'] = 'fakeid';
    defaultValues['contact.name'] = 'Fake Name';
    defaultValues['contact.email'] = 'foo@bar.com';
    defaultValues['images'] = [];
    defaultValues['pathologyReports'] = [];
    defaultValues['consent'] = true;
    defaultValues['dataUsePermissions'] = "Share full record";
    defaultValues['speciesName'] = "genus x";
    context.browser.generateFormData("Reports", function(generatedValues){
      defaultValues = _.extend(generatedValues, defaultValues);
      // These fields are deleted because setFormFields does not support them.
      var badKeys = [
        'specifyOtherRanavirusSampleTypes',
        'specifyOtherRanavirusConfirmationMethods',
        'specifyOtherVertebrateClasses',
        'sampleType',
        'ranavirusConfirmationMethods',
        'eventDate',
        'genBankAccessionNumbers',
        'eventLocation',
        'sourceFile',
        'studyId'
      ];
      defaultValues = _.omit(defaultValues, badKeys);
      if(!_.isEmpty(_.pick(customValues, badKeys))) {
        throw Error("Bad keys: " + _.pick(customValues, badKeys));
      }
      var formData = _.extend(defaultValues, customValues);
      context.lastFormData = formData;
      context.browser.setFormFields(formData, 'Reports', callback);
    });
  };

  module.exports = function () {

    this.When(/^I fill out the form setting "([^"]+)" to "([^"]+)"$/,
    function(field, value, callback){
      var customValues = {};
      customValues[field] = value;
      helper.fillInForm(customValues, callback);
    });

    this.When(/^I fill out the form with the (eventDate) "([^"]*)"$/,
    function(prop, value, callback){
      var customValues = {};
      customValues[prop] = value;
      fillInReportForm(this, customValues, callback);
    });

    this.When("I fill out the form", function(callback){
      fillInReportForm(this, {}, callback);
    });

    this.Then("the data I filled out the form with should be in the database",
    function(callback){
      this.browser
      .waitForReport(this.lastFormData)
      .call(callback);
    });


    this.When("I fill out a report without consenting to publish it",
    function(callback){
      var customValues = {};
      customValues['consent'] = false;
      fillInReportForm(this, customValues, callback);
    });

    this.When("I fill out a report with obfuscated permissions",
    function(callback){
      var customValues = {};
      customValues['dataUsePermissions'] = 'Share obfuscated';
      fillInReportForm(this, customValues, callback);
    });

    this.When('I fill out the $field field with "$value"',
    function(field, value, callback){
      this.browser
      .setValue('[data-schema-key="' + field + '"]', value)
      .pause(500)
      .call(callback);
    });

    this.When('I choose "$value" for the $field field',
    function(value, field, callback){
      this.browser
      .click('div[data-schema-key="' + field + '"] input[value="' + value + '"]')
      .call(callback);
    });

    this.When('I select the #(\d+) study',
    function(studyIndex, callback){
      this.browser
      .selectByIndex('select[data-schema-key="studyId"]', parseInt(studyIndex))
      .call(callback);
    });

    this.Then('the $field field should have the value "$value"',
    function(field, value, callback){
      this.browser
      .mustExist('[data-schema-key="' + field + '"]')
      .checkValue('[data-schema-key="' + field + '"]', value)
      .call(callback);
    });


    this.When("I add a pathology report", function(callback){
      this.browser
      .click('div[data-schema-key="pathologyReports.0.notified"] input[value="Yes"]')
      .click('.autoform-add-item[data-autoform-field="pathologyReports"]')
      .mustExist('[data-schema-key="pathologyReports.0.report"]')
      .chooseFile(
        'input[file-input="pathologyReports.0.report"]',
        // This is a random pdf file that was selected because it is
        // in the public domain.
        // Source:
        // http://commons.wikimedia.org/wiki/File:15_Years_ISS_-_Infographic.pdf
        path.join(this.getAppDirectory(), "tests", "files", "NASA.pdf"),
        function(err){
          assert.isError(err);
        }
      )
      .call(callback);
    });

    this.When("I upload an image", function(callback){
      this.browser
      .click('.autoform-add-item[data-autoform-field="images"]')
      .mustExist('input[file-input="images.0.image"]')
      .chooseFile(
        'input[file-input="images.0.image"]',
        path.join(this.getAppDirectory(), "tests", "files", "logo.png"),
        function(err){
          assert.ifError(err);
        }
      )
      .call(callback);
    });

    this.Then("I should see an image preview", function(callback){
      this.browser
      .pause(2000)
      .mustExist('.img-fileUpload-thumbnail')
      .call(callback);
    });

    this.Then(/^the webpage should( not)? display the (.+) field$/,
    function(shouldNot, field, callback){
      var reverse = !!shouldNot;
      this.browser
      // custom errors on groups don't create a has-error class
      .waitForExist('[data-schema-key="' + field + '"]', 2000, reverse,
      function(err, result){
        assert.equal(err, null);
        if(shouldNot) {
          assert(result, "Field is incorrectly displayed");
        } else {
          assert(result, "Missing field");
        }
      }).call(callback);
    });

    this.Then(/^the webpage should( not)? display a validation error$/,
    function(shouldNot, callback){
      var that = this;
      var reverse = Boolean(shouldNot);
      var chain = this.browser
      // Custom errors on groups don't create a has-error class.
      // Also, fields with a uniqueness constraint will not retain their
      // error message if they are refocused. When testing, I believe
      // something triggers refocus events causing their has-error
      // class to be wiped out, so I also check for error toasts.
      .waitForExist('.has-error, .help-block:not(:empty), .toast-error', 3000, reverse,
      function(err, result){
        assert.ifError(err);
        if(shouldNot) {
          if(!result) {
            that.browser
            .saveScreenshot(
              that.getAppDirectory() +
              "/tests/screenshots/validation error - " +
              that.scenario.getName() +
              ".png"
            );
          }
          assert(result, "Validation error");
        } else {
          assert(result, "Missing validation error");
        }
      });
      if(!shouldNot) {
        //Dismiss the toast so it doesn't get in the way of the submit button
        chain = chain
          .clickWhenVisible('.toast')
          .pause(1000);
      }
      chain.call(callback);
    });

    this.Then('I should see a "$message" toast',
    function(message, callback){
      this.browser
      .waitForVisible(".toast-success", function (err) {
        assert(!err);
      })
      .mustExist(".toast-success")
      .getText(".toast-success", function(err, text){
        assert(!err);
        var regexString = message
          .split(" ")
          .join("\\s+");
        assert(RegExp(regexString, "i").test(text), message + " not found in " + text);
      }).call(callback);
    });

    this.Then("the information for the institution fields should be prepopulated",
    function(callback){
      this.browser
      .pause(2000)
      .checkValue('[data-schema-key="contact.institutionAddress.name"]', "EHA")
      .checkValue('[data-schema-key="contact.institutionAddress.street"]', "460 West 34th Street – 17th floor")
      .checkValue('[data-schema-key="contact.institutionAddress.city"]', "New York")
      .checkValue('[data-schema-key="contact.institutionAddress.stateOrProvince"]', "NY")
      .checkValue('[data-schema-key="contact.institutionAddress.country"]', "USA")
      .checkValue('[data-schema-key="contact.institutionAddress.postalCode"]', "10001")
      .call(callback);
    });

    this.Then("the information from the study should be prepopulated",
    function(callback){
      this.browser
      .pause(2000)
      .checkValue('[data-schema-key="speciesGenus"]', "SomeGenus")
      .call(callback);
    });

    this.Then(/^I should( not)? see the review panel header$/, function(shouldNot, callback){
      var reverse = !!shouldNot;
      this.browser.waitForExist('.review-panel-header', 2000, reverse,
      function(err, result){
        assert.equal(err, null);
        if(shouldNot) {
          assert(result, "Review panel head incorrectly displayed");
        } else {
          assert(result, "Missing review panel header");
        }
      }).call(callback);
    });

    this.Then('I should see the report form', function(callback){
      this.browser.waitForVisible('#ranavirus-report', 2000,
      function(err, result){
        assert.equal(err, null);
        assert(result, "Missing report form");
      }).call(callback);
    });

  };

})();
