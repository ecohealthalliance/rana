(function () {

  'use strict';

  var assert = require('assert');
  var path = require('path');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.When("I open the review panel", function(callback){
      helper.world.browser
      .click('.review-panel-header')
      .call(callback);
    });

    this.When(/^I enter the rating (\d+)$/, function (rating, callback) {
      helper.world.browser
      .setValue('input[name=rating]', rating)
      .call(callback);
    });

    this.When(/^I enter the comment "([^"]*)"$/, function (comment, callback) {
      helper.world.browser
      .setValue('.new-comment', comment)
      .call(callback);
    });

    this.When("I add the review", function (callback) {
      helper.world.browser
      .click('.add-comment')
      .call(callback)
    });

    this.Then(/^the review panel should( not)? appear/, function (shouldNot, callback) {
      helper.world.browser
      .waitForExist('.review-content > .panel', 1000, function (err, exists) {
        assert.ifError(err);
        if (shouldNot) {
          assert(!exists, "the review panel should not be visible");
        } else {
          assert(exists, "the review panel should be visible");
        }
      }).call(callback);
    });
  };

})();
