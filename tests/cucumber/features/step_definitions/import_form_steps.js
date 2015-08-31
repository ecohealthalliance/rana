//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');
  var _ = require("underscore");

  module.exports = function () {

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

    csvImportValues['rana_import_utm.csv'] = [
      ['screeningReason', 'mortality'],
      ['speciesGenus', 'lizardo'],
      ['speciesName', 'lizardo bizarro'],
      ['eventDate', '3/4/2003'],
      ['eventLocation', {
        "source" : "utm",
        "northing" : 5698366.5771494,
        "easting" : 705619.99432907,
        "zone" : 30,
        "degreesLon" : -1,
        "minutesLon" : 57,
        "secondsLon" : 21.796884000000105,
        "degreesLat" : 51,
        "minutesLat" : 23,
        "secondsLat" : 57.14033999999619,
        "country" : "UK",
        "geo" : {
          "type" : "Point",
          "coordinates" : [
            -0.04394531,
            51.39920565
          ]
        }
      }]
    ];

    this.When(/^I upload the CSV file (.*)$/, function(filename, callback){

      this.browser
      .mustExist('[data-schema-key="csvFile"]')
      .chooseFile(
        'input[file-input="csvFile"]',
        path.join(this.getAppDirectory(), "tests", "files", "csv", filename),
        function(err){
          assert.equal(err, null);
        }
      )
      .call(callback);
    });

    this.When("I remove the CSV file", function(callback){
      this.browser
      .clickWhenVisible('.file-upload-clear[file-input="csvFile"]')
      .pause(500)
      .call(callback);
    });

    // This step is currently unused.
    this.Then(/^the preview table should contain the values for (.*)$/, function(filename, callback){
      this.browser.checkTableCells(csvImportValues[filename], callback);
    });

    this.Then(/^the form should contain the values for (.*)$/, function(filename, callback){
      this.browser.checkFormFields('ranavirus-report', csvImportValues[filename], callback);
    });

  };

})();
