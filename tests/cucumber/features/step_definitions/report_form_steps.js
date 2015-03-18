//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.fillInForm = function (customValues, callback) {
      helper.world.browser
      .waitForExist('.form-group', function (err, exists) {
        assert(!err);
        assert(exists);
      })
      .execute(function(){
        var schema = collections.Reports.simpleSchema()._schema;
        var types = {};
        _.each(schema, function (value, key) {
          // studyId is designated as a select via options passed in via
          // a helper, so it's not in the schema and can't be detected here.
          if (key == 'studyId') {
            types[key] = 'select';
          }   else if (value.optional) {
              types[key] = 'optional';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.afFieldInput.options &&
              value.autoform.afFieldInput.noselect) {
            types[key] = 'radio';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.options &&
              value.autoform.afFieldInput.noselect) {
            types[key] = 'radio';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.afFieldInput.options) {
            types[key] = 'select';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.options) {
            types[key] = 'select';
          } else if (value.autoform &&
                     value.autoform.rows) {
            types[key] = 'textarea';
          } else if (value.autoform &&
                     value.autoform.afFieldValueContains) {
            types[key] = 'optional';
          } else {
            types[key] = value.type.name;
          }
        });

        return {
          formData: AutoForm.Fixtures.getData(collections.Reports.simpleSchema()),
          schemaTypes: types
        };
      }, function(err, res){
        if(err) {
          return callback.fail(err);
        } else {
          var schemaTypes = res.value.schemaTypes;
          var generatedFormData = res.value.formData;
          generatedFormData['studyId'] = 'fakeid';
          generatedFormData['contact']['institutionAddress']['postalCode'] = '12345';
          generatedFormData['images'] = [];
          generatedFormData['pathologyReports'] = [];
          generatedFormData['eventLocation'] = null;
          if (generatedFormData.hasOwnProperty('eventDate')) {
            generatedFormData['eventDate'] = new Date(
              JSON.parse(generatedFormData['eventDate']))
              .toISOString().slice(0,10);
          }
          _.extend(generatedFormData, customValues);
          var browser = helper.world.browser;
          _.each(generatedFormData, function (value, key) {
            if (schemaTypes[key] === 'String' ||
                schemaTypes[key] === 'Number') {
              if (value) {
                browser.setValue('input[data-schema-key="' + key + '"]', value);
              }
            } else if (schemaTypes[key] === 'textarea') {
              browser.setValue('textarea[data-schema-key="' + key + '"]', value);
            } else if (schemaTypes[key] === 'Boolean') {
              browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
            } else if (schemaTypes[key] === 'radio') {
              browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
            } else if (schemaTypes[key] === 'select') {
              browser.selectByValue('select[data-schema-key="' + key + '"]', value);
            } else if (schemaTypes[key] === 'Array') {
              _.each(value, function (element) {
                browser.click('div[data-schema-key="' + key + '"] input[value="' + element + '"]');
              });
            } else if (schemaTypes[key] === 'Date') {
              browser.setValue('input[data-schema-key="' + key + '"]', '');
            } else if (schemaTypes[key] === 'Object') {
              _.each(value, function (subValue, subKey) {
                var schemaKey = key + '.' + subKey;
                browser.setValue('input[data-schema-key="' + schemaKey + '"]', subValue);
              });
            } else if (schemaTypes[key] = 'optional') {
              // do nothing
            } else {
              var error = 'unknown type in schema: ' + schemaTypes[key];
              throw new Error(error);
            }
          });
          callback();
        }});
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

    this.When("I fill out a report without consenting to publish it",
    function(callback){
      var customValues = {};
      customValues['consent'] = false;
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

    this.When("I add a pathology report", function(callback){

      helper.world.browser
      .click('div[data-schema-key="pathologyReportPermission"] input[value="Yes"]')
      .click('.autoform-add-item[data-autoform-field="pathologyReports"]')
      .mustExist('[data-schema-key="pathologyReporc ts.0.report"]')
      .chooseFile(
        'input[file-input="pathologyReports.0.report"]',
        // This is a random pdf file that was selected because it is
        // in the public domain.
        // Source:
        // http://commons.wikimedia.org/wiki/File:15_Years_ISS_-_Infographic.pdf
        path.join(helper.getAppDirectory(), "tests", "files", "NASA.pdf"),
        function(err){
          assert.equal(err, null);
        }
      )
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
      var reverse = !!shouldNot;
      helper.world.browser
      // custom errors on groups don't create a has-error class
      .waitForExist('.has-error, .help-block:not(:empty)', 2000, reverse,
      function(err, result){
        console.log("err:", err, 'result', result);
        assert.equal(err, null);

        if(shouldNot) {
          assert(result, "Validation error");
        } else {
          assert(result, "Missing validation error");
        }
      }).call(callback);
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
      .checkValue('[data-schema-key="institutionAddress.name"]', "EHA")
      .checkValue('[data-schema-key="institutionAddress.street"]', "460 West 34th Street – 17th floor")
      .checkValue('[data-schema-key="institutionAddress.city"]', "New York")
      .checkValue('[data-schema-key="institutionAddress.stateOrProvince"]', "NY")
      .checkValue('[data-schema-key="institutionAddress.country"]', "USA")
      .checkValue('[data-schema-key="institutionAddress.postalCode"]', "10001")
      .call(callback);
    });
  };

})();
