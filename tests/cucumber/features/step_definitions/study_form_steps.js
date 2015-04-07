//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.fillInStudyForm = function (customValues, callback) {

      var defaultValues = {};
      defaultValues['contact.name'] = 'Fake Name';
      defaultValues['contact.email'] = 'foo@bar.com';
      defaultValues['consent'] = true;
      defaultValues['dataUsePermissions'] = "Share full record";
      defaultValues['name'] = "Study";

      _.extend(defaultValues, customValues);

      helper.world.browser.setFormFields(defaultValues, 'Studies', callback);

    };

    this.When("I fill out the study form", function(callback){
      helper.fillInStudyForm({}, callback);
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

    this.When("I do not provide text for the reference field", function(callback){
      helper.world.browser
      .setValue('[data-schema-key="publicationInfo.reference"]', '')
      .call(callback);
    });

  };

})();
