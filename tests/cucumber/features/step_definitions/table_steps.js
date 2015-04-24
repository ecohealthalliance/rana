//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;
    
    this.Then(/^I should see (\d+) reports? in the table$/, function (number, callback) {
      helper.world.browser
      .waitForExist(".reactive-table tbody tr")
      .elements(".reactive-table tbody tr", function(err, resp){
        assert.ifError(err);
        assert.equal(resp.value.length, parseInt(number));
      })
      .call(callback);
    });

    this.Then("I should not see a checkbox for the edit column", function (callback) {
      helper.world.browser
      .getTextWhenVisible('.reactive-table-columns-dropdown li:last-child label',
      function(err, text){
        assert(!err);
        assert.notEqual(text.trim(), "", "Controls column has visible checkbox.");
      })
      .call(callback);
    });

  };

})();