//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    var csvImportValues = {};
      csvImportValues['rana_import_one.csv'] = [
        ['screeningReason', 'mortality'],
        ['speciesGenus', 'abstracticus'],
        ['speciesName', 'genericus'],
        ['eventDate', '1/2/2010']
      ];

    this.fillInStudyForm = function (customValues, callback) {

      var defaultValues = {};
      defaultValues['contact.name'] = 'Fake Name';
      defaultValues['contact.email'] = 'foo@bar.com';

      _.extend(defaultValues, customValues);

      helper.world.browser.setFormFields(defaultValues, 'Studies', callback);

    }

    this.When("I fill out the study form", function(callback){
      helper.fillInStudyForm({}, callback);
    });

    this.When(/^I upload the CSV file (.*)$/, function(filename, callback){

      helper.world.browser
      .mustExist('[data-schema-key="csvFile"]')
      .chooseFile(
        'input[file-input="csvFile"]',
        path.join(helper.getAppDirectory(), "tests", "files", "csv", filename),
        function(err){
          assert.equal(err, null);
        }
      )
      .call(callback);
    });

    this.Then(/^the preview table should contain the values for (.*)$/, function(filename, callback){
      helper.world.browser.checkTableCells(csvImportValues[filename], callback);
    });

    this.Then(/^the form should contain the values for (.*)$/, function(filename, callback){
      helper.world.browser.checkFormFields('ranavirus-report', csvImportValues[filename], callback);
    });

  };

})();
