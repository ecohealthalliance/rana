//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  var helpers = require('./helpers')

  module.exports = function () {

    var helper = this;

    this.fillInStudyForm = function (customValues, callback) {
      helper.world.browser
      .waitForExist('.form-group', function (err, exists) {
        assert(!err);
        assert(exists);
      })
      .execute(function(){
        return AutoForm.Fixtures.getData(collections.Studies.simpleSchema());
      }, function(err, res){
        if(err) {
          return callback.fail(err);
        } else {
          var generatedFormData = res.value;
          generatedFormData['contact']['name'] = 'Fake Name';
          generatedFormData['contact']['email'] = 'foo@bar.com';
          _.extend(generatedFormData, customValues);
          helpers.setFormFields(collections.Studies.simpleSchema()._schema,
                                generatedFormData,
                                helper.world.browser);
        }
        callback();
      });
    };

    this.When("I fill out the study form", function(callback){
      helper.fillInStudyForm({}, callback);
    });

  };

})();
