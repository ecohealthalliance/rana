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

      _.extend(defaultValues, customValues);

      helper.world.browser.setFormFields(defaultValues, 'Studies', callback);

    }

    this.When("I fill out the study form", function(callback){
      helper.fillInStudyForm({}, callback);
    });


    this.When("I fill out the study form with some default report values", function(callback){
      helper.fillInStudyForm({'speciesGenus': 'SomeGenus'}, callback);
    });

    this.When("I fill out the study form differently", function(callback){
      helper.fillInStudyForm({ 'contact.name': 'Aother Fake Name',
                               'contact.email': 'zap@bop.com' }, callback);
    });

  };

})();
