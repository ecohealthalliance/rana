//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');
  var _ = require("underscore");

  var fillInStudyForm = function (context, customValues, callback) {
    var studyDefaultValues = {
      'contact.name': 'Fake Name',
      'contact.email': 'foo@bar.com',
      'consent': true,
      'dataUsePermissions': "Share full record",
      'name': "Study"
    };
    var values = _.extend(studyDefaultValues, customValues);
    context.browser.setFormFields(values, 'Studies', callback);
  };

  module.exports = function () {

    // This must override all studyDefaultValues defined in fillInStudyForm()
    var studyDifferentValues = {
      'name': 'Obfuscated study',
      'contact.name': 'Another Fake Name',
      'contact.email': 'zap@bop.com',
      'dataUsePermissions': 'Share obfuscated',
      'consent': true
    };

    this.When("I fill out the study form", function(callback){
      fillInStudyForm(this, {}, callback);
    });

    this.When("I fill out the study form with some default report values", function(callback){
      fillInStudyForm(this, {'speciesGenus': 'SomeGenus'}, callback);
    });

    this.When(/I fill out the study form differently(?: with obfuscated permissions)?/, function(callback){
      fillInStudyForm(this, studyDifferentValues, callback);
    });

    this.When('I click the $buttonType button for the study called "$name"', function(buttonType, name, callback){
      this.browser
      .pause(2000)
      .click('a.' + buttonType + '[for="' + name + '"]')
      .call(callback);
    });

    this.When(/I upload a (non-)?pdf publication/, function(nonPdf, callback){
      var filepath;
      if(nonPdf) {
        filepath = path.join(this.getAppDirectory(), "README.md");
      } else {
        filepath = path.join(this.getAppDirectory(), "tests", "files", "NASA.pdf");
      }
      this.browser
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

    this.Then(/^the form should contain the different values I entered$/, function (callback) {
      var valuesArr = _.map(studyDifferentValues, function(val, key) {
        return [key, val]
      });
      this.browser.checkFormFields('ranavirus-study', valuesArr, callback);
    });

    this.Then(/^the publication should( not)? appear/, function(shouldNot, callback){
      this.browser
      .waitForExist('.file-upload-clear[file-input="publicationInfo.pdf"]', 1000, Boolean(shouldNot), function(err, indicator){
        assert.ifError(err);
        assert(indicator, "The publication should " + (shouldNot ? "not" : "" ) + " appear");
      })
      .call(callback);
    });

    this.When("I remove the publication", function(callback){
      this.browser
      .pause(500)
      .clickWhenVisible('.file-upload-clear[file-input="publicationInfo.pdf"]')
      .pause(500)
      .call(callback);
    });

    this.When("I do not provide text for the reference field", function(callback){
      this.browser
      .setValue('[data-schema-key="publicationInfo.reference"]', '')
      .call(callback);
    });


  this.Then(/^the webpage should( not)? display an? (.+) button for the '(.+)' study$/,
    function(shouldNot, buttonType, studyName, callback){
      var reverse = !!shouldNot;
      this.browser
      // custom errors on groups don't create a has-error class
      .waitForExist('a.' + buttonType + '[for="' + studyName + '"]', 1000, reverse,
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
    this.browser.waitForVisible('#ranavirus-study', 2000,
    function(err, result){
      assert.equal(err, null);
      assert(result, "Missing study form");
    }).call(callback);
  });

  };

})();
