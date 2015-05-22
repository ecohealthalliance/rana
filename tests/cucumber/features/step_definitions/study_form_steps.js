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
      ['speciesName', 'abstracticus genericus'],
      ['eventDate', '1/2/2010']
    ];

    csvImportValues['rana_import_complete.csv'] = [
      ['contact.name', 'Test User'],
      ['contact.email', 'test@tester.com'],
      ['contact.phone', '123 555 4444'],
      ['contact.institutionAddress.name', 'University of Testing'],
      ['contact.institutionAddress.street', '123 Fake St'],
      ['contact.institutionAddress.street2', 'Second Floor'],
      ['contact.institutionAddress.city', 'Cityville'],
      ['contact.institutionAddress.stateOrProvince', 'CA'],
      ['contact.institutionAddress.country', 'USA'],
      ['contact.institutionAddress.postalCode', '12221'],
      ['eventLocation',
        { 'source': 'LonLat',
          'northing': 5410809.438552289,
          'easting': 452694.4771719082,
          'zone': 31,
          'geo': {
            'type': 'Point',
            'coordinates': [2.355194091796875, 48.84845083589778]
          },
          'degreesLon': 2,
          'minutesLon': 21,
          'secondsLon': 18.698730468750078,
          'degreesLat': 48,
          'minutesLat': 50,
          'secondsLat': 54.42300923200478,
          'country': 'USA'
        }
      ],
      ['numInvolved', '2_10'],
      ['totalAnimalsTested', 22],
      ['totalAnimalsConfirmedInfected', 20],
      ['totalAnimalsConfirmedDiseased', 19],
      ['genBankAccessionNumbers',
        [
          { 'genBankAccessionNumber': '123AAAZ' },
          { 'genBankAccessionNumber': 'XXCCVV' },
          { 'genBankAccessionNumber': 'LLKK1' }
        ]
      ],
      ['populationType', 'wild'],
      ['vertebrateClasses', ['fish','reptile']],
      ['ageClasses', ['egg','larvae']],
      ['speciesGenus', 'abstracticus'],
      ['speciesName', 'abstracticus genericus'],
      ['speciesNotes', 'One of the nicest species you will ever meet.'],
      ['speciesAffectedType', 'native'],
      ['ranavirusConfirmationMethods', ['traditional_pcr','electron_microscopy','immunohistochemistry','other']],
      ['sampleType', ['internal_organ_tissues','other']],
      ['additionalNotes', 'Additional notes here. Lots of notes'],
      ['consent', true],
      ['dataUsePermissions', 'Do not share']
    ];

    var studyDefaultValues = {
      'contact.name': 'Fake Name',
      'contact.email': 'foo@bar.com',
      'consent': true,
      'dataUsePermissions': "Share full record",
      'name': "Study"
    }

    var studyDifferentValues = {
      'name': 'Obfuscated study',
      'contact.name': 'Another Fake Name',
      'contact.email': 'zap@bop.com',
      'dataUsePermissions': 'Share obfuscated'
    }

    this.fillInStudyForm = function (customValues, callback) {

      var values = _.extend({}, studyDefaultValues, customValues);

      helper.world.browser.setFormFields(values, 'Studies', callback);

    };

    this.When("I fill out the study form", function(callback){
      helper.fillInStudyForm({}, callback);
    });

    this.When("I fill out the study form with some default report values", function(callback){
      helper.fillInStudyForm({'speciesGenus': 'SomeGenus'}, callback);
    });

    this.When(/I fill out the study form differently(?: with obfuscated permissions)?/, function(callback){
      helper.fillInStudyForm(studyDifferentValues, callback);
    });

    this.When('I click the $buttonType button for the study called "$name"', function(buttonType, name, callback){
      helper.world.browser
      .pause(2000)
      .click('a.btn-' + buttonType + '[for="' + name + '"]')
      .call(callback);
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

    this.When(/I upload a (non-)?pdf publication/, function(nonPdf, callback){
      var filepath;
      if(nonPdf) {
        filepath = path.join(helper.getAppDirectory(), "README.md");
      } else {
        filepath = path.join(helper.getAppDirectory(), "tests", "files", "NASA.pdf");
      }
      helper.world.browser
      .click('div[data-schema-key="publicationInfo.dataPublished"] input[value=true]')
      .mustExist('[data-schema-key="publicationInfo.pdf"]')
      .chooseFile(
        'input[file-input="publicationInfo.pdf"]',
        filepath,
        function(err){
          assert.equal(err, null);
        }
      )
      .call(callback);
    });

    // This step is currently unused.
    this.Then(/^the preview table should contain the values for (.*)$/, function(filename, callback){
      helper.world.browser.checkTableCells(csvImportValues[filename], callback);
    });

    this.Then(/^the form should contain the values for (.*)$/, function(filename, callback){
      helper.world.browser.checkFormFields('ranavirus-report', csvImportValues[filename], callback);
    });

    this.Then(/^the form should contain the different values I entered$/, function (callback) {
      var values = _.extend({}, studyDefaultValues, studyDifferentValues)
      var valuesArr = _.map(values, function(val, key) { return [key, val] } )
      helper.world.browser.checkFormFields('ranavirus-study', valuesArr, callback);
    });

    this.Then(/^the publication should( not)? appear/, function(shouldNot, callback){
      helper.world.browser
      .waitForExist('.file-upload-clear[file-input="publicationInfo.pdf"]', 1000, Boolean(shouldNot), function(err, indicator){
        assert.ifError(err);
        assert(indicator, "The publication should " + (shouldNot ? "not" : "" ) + " appear");
      })
      .call(callback);
    });

    this.When("I remove the publication", function(callback){
      helper.world.browser
      .pause(500)
      .clickWhenVisible('.file-upload-clear[file-input="publicationInfo.pdf"]')
      .pause(500)
      .call(callback);
    });

    this.When("I remove the CSV file", function(callback){
      helper.world.browser
      .pause(500)
      .clickWhenVisible('.file-upload-clear[file-input="csvFile"]')
      .pause(500)
      .call(callback);
    });

    this.When("I do not provide text for the reference field", function(callback){
      helper.world.browser
      .setValue('[data-schema-key="publicationInfo.reference"]', '')
      .call(callback);
    });


  this.Then(/^the webpage should( not)? display an? (.+) button for the '(.+)' study$/,
    function(shouldNot, buttonType, studyName, callback){
      var reverse = !!shouldNot;
      helper.world.browser
      // custom errors on groups don't create a has-error class
      .waitForExist('a.btn-' + buttonType + '[for="' + studyName + '"]', 1000, reverse,
      function(err, result){
        assert.equal(err, null);
        if(shouldNot) {
          assert(result, buttonType + ' button for ' + studyName + ' should not be displayed');
        } else {
          assert(result, buttonType + ' button for ' + studyName + ' is missing');
        }
      }).call(callback);
    });

  this.Then('I should see the study form', function(callback){
    helper.world.browser.waitForVisible('#ranavirus-study', 2000,
    function(err, result){
      assert.equal(err, null);
      assert(result, "Missing study form");
    }).call(callback);
  });

  };

})();
