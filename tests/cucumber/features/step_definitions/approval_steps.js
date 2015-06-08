//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = require("underscore");

  module.exports = function () {

    this.When(/^I approve the report$/, function(callback){
      this.browser
        .clickWhenVisible(".approve-report")
        .call(callback);
    });

    this.When(/^I approve the user$/, function(callback){
      this.browser
        .clickWhenVisible(".approve-user")
        .call(callback);
    });

    this.Then(/^I should see the "(.*)" approval button$/, function(buttonId, callback){
      this.browser.waitForExist('#' + buttonId, 3000,
      function(err, result){
        assert.equal(err, null);
        assert(result, "Missing #" + buttonId + ' button');
      }).call(callback);
    });

    this.When(/^I click on the "(.*)" approval button$/,
      function(buttonId, callback){
        this.browser
        .click('#' + buttonId)
        .call(callback);
      });


  };

})();