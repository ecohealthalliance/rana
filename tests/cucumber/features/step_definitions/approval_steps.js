//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.When(/^I approve the report$/, function(callback){
      helper.world.browser
        .clickWhenVisible(".approve-report")
        .call(callback);
    });

    this.When(/^I approve the user$/, function(callback){
      helper.world.browser
        .clickWhenVisible(".approve-user")
        .call(callback);
    });

  };

})();