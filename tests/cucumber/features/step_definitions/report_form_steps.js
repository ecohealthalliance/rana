//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.fillInForm = function (customValues, callback) {
      var defaultValues = {};
      defaultValues['studyId'] = 'fakeid';
      defaultValues['contact.name'] = 'Fake Name';
      defaultValues['contact.email'] = 'foo@bar.com';
      defaultValues['images'] = [];
      defaultValues['pathologyReports'] = [];
      defaultValues['consent'] = true;
      defaultValues['dataUsePermissions'] = "Share full record";
      defaultValues['speciesName'] = "genus x";
      helper.world.browser.generateFormData("Reports", function(generatedValues){
        defaultValues = _.extend(generatedValues, defaultValues);
        // These fields are deleted because setFormFields does not support them.
        var badKeys = [
          'specifyOtherRanavirusSampleTypes',
          'specifyOtherRanavirusConfirmationMethods',
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
        helper.lastFormData = formData;
        helper.world.browser.setFormFields(formData, 'Reports', callback);
      });
    };

    this.When(/^I fill out the form with the (eventDate) "([^"]*)"$/,
    function(prop, value, callback){
      var customValues = {};
      customValues[prop] = value;
      helper.fillInForm(customValues, callback);
    });

    this.When("I fill out the form", function(callback){
      helper.fillInForm({}, callback);
    });

    this.Then("the data I filled out the form with should be in the database",
    function(callback){
      helper.world.browser
      .waitForReport(helper.lastFormData)
      .call(callback);
    });


    this.When("I fill out a report without consenting to publish it",
    function(callback){
      var customValues = {};
      customValues['consent'] = false;
      helper.fillInForm(customValues, callback);
    });

    this.When("I fill out a report with obfuscated permissions",
    function(callback){
      var customValues = {};
      customValues['dataUsePermissions'] = 'Share obfuscated';
      helper.fillInForm(customValues, callback);
    });

    this.When('I fill out the $field field with "$value"',
    function(field, value, callback){
      helper.world.browser
      .setValue('[data-schema-key="' + field + '"]', value)
      .pause(500)
      .call(callback);
    });

    this.When('I choose "$value" for the $field field',
    function(value, field, callback){
      helper.world.browser
      .click('div[data-schema-key="' + field + '"] input[value="' + value + '"]')
      .call(callback);
    });

    this.When('I select the #(\d+) study',
    function(studyIndex, callback){
      helper.world.browser
      .selectByIndex('select[data-schema-key="studyId"]', parseInt(studyIndex))
      .call(callback);
    });

    this.Then('the $field field should have the value "$value"',
    function(field, value, callback){
      helper.world.browser
      .mustExist('[data-schema-key="' + field + '"]')
      .checkValue('[data-schema-key="' + field + '"]', value)
      .call(callback);
    });


    this.When("I add a pathology report", function(callback){
      helper.world.browser
      .click('div[data-schema-key="pathologyReports.0.notified"] input[value="Yes"]')
      .click('.autoform-add-item[data-autoform-field="pathologyReports"]')
      .mustExist('[data-schema-key="pathologyReports.0.report"]')
      .chooseFile(
        'input[file-input="pathologyReports.0.report"]',
        // This is a random pdf file that was selected because it is
        // in the public domain.
        // Source:
        // http://commons.wikimedia.org/wiki/File:15_Years_ISS_-_Infographic.pdf
        path.join(helper.getAppDirectory(), "tests", "files", "NASA.pdf"),
        function(err){
          assert.isError(err);
        }
      )
      .call(callback);
    });

    this.When("I upload an image", function(callback){
      helper.world.browser
      .click('.autoform-add-item[data-autoform-field="images"]')
      .mustExist('input[file-input="images.0.image"]')
      .chooseFile(
        'input[file-input="images.0.image"]',
        path.join(helper.getAppDirectory(), "tests", "files", "logo.png"),
        function(err){
          assert.ifError(err);
        }
      )
      .call(callback);
    });

    this.Then("I should see an image preview", function(callback){
      helper.world.browser
      .pause(2000)
      .mustExist('.img-fileUpload-thumbnail')
      .call(callback);
    });

    this.Then(/^the webpage should( not)? display the (.+) field$/,
    function(shouldNot, field, callback){
      var reverse = !!shouldNot;
      helper.world.browser
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
      var reverse = Boolean(shouldNot);
      var chain = helper.world.browser
      // custom errors on groups don't create a has-error class
      .waitForExist('.has-error, .help-block:not(:empty)', 2000, reverse,
      function(err, result){
        assert.ifError(err);
        if(shouldNot) {
          if(!result) {
            helper.world.browser
            .saveScreenshot(
              helper.getAppDirectory() +
              "/tests/screenshots/validation error - " +
              helper.world.scenario.getName() +
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
      helper.world.browser
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
      helper.world.browser
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
      helper.world.browser
      .pause(2000)
      .checkValue('[data-schema-key="speciesGenus"]', "SomeGenus")
      .call(callback);
    });
  };

})();
