//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var _ = require('underscore');

  var fillInProfileForm = function (context, customValues, callback) {
    _.each(customValues, function (value, key) {
      context.browser.mustExist('.form-group').
      setValue('input[data-schema-key="' + key + '"]', value);
    });
    callback();
  };

  module.exports = function () {

    var profileDifferentValues = {
      'organization': 'A different organization',
      'organizationStreet': 'New street',
      'organizationStreet2': 'Another new street'
    };

    this.When("I fill out the profile form differently", function(callback){
      fillInProfileForm(this, profileDifferentValues, callback);
    });

    this.Then(/^the form should contain the different profile values I entered$/, function (callback) {
      var valuesArr = _.map(profileDifferentValues, function(val, key) {
        return [key, val];
      });
      this.browser.checkFormFields('update-user-profile-form', valuesArr, callback);
    });

  };

})();
