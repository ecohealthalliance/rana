//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    var profileDifferentValues = {
      'organization': 'A different organization',
      'organizationStreet': 'New street',
      'organizationStreet2': 'Another new street'
    }

    this.fillInProfileForm = function (customValues, callback) {
      _.each(customValues, function (value, key) {
        helper.world.browser.mustExist('.form-group').
        setValue('input[data-schema-key="' + key + '"]', value);
      });
      callback();
    };

    this.When("I fill out the profile form differently", function(callback){
      helper.fillInProfileForm(profileDifferentValues, callback);
    });

    this.Then(/^the form should contain the different profile values I entered$/, function (callback) {
      var valuesArr = _.map(profileDifferentValues, function(val, key) { return [key, val] } )
      helper.world.browser.checkFormFields('update-user-profile-form', valuesArr, callback);
    });

  };

})();
