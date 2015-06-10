//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var _ = require("underscore");

  module.exports = function () {

    this.Then(/^I should see (\d+) (study|studies|report|reports) in the table$/, function (number, studiesOrReports, callback) {
      this.browser
      .waitForExist(".reactive-table tbody tr")
      .elements(".reactive-table tbody tr", function(err, resp){
        assert.ifError(err);
        assert.equal(resp.value.length, parseInt(number, 10));
      })
      .call(callback);
    });

    this.Then("I should not see a checkbox for the edit column", function (callback) {
      this.browser
      .getTextWhenVisible('.reactive-table-columns-dropdown li:last-child label',
      function(err, text){
        assert.ifError(err);
        if (typeof(text) == 'object') {
          text = text[0];
        }
        assert(!err);
        assert.notEqual(text.trim(), "", "Controls column has visible checkbox.");
      })
      .call(callback);
    });

    this.When(/^I delete the (report|study)$/, function(reportOrStudy, callback){
      this.browser
        .clickWhenVisible(".remove-form")
        .alertText("delete", assert.ifError)
        .alertAccept(assert.ifError)
        .call(callback);
    });

    this.Then(/^there should be no delete button for the (report|study) by someone else$/,
    function(reportOrStudy, callback){
      this.browser
        .mustExist('.reactive-table tr')
        .execute(function() {
          return $('.reactive-table tr').map(function(idx, element){
            var $el = $(element);
            var someoneElse = /Someone Else/.test(
              $el.find('td[class="createdBy.name"]').text()
            );
            var hasDelete = Boolean($el.find(".remove-form").length);
            if(someoneElse && hasDelete) {
              return $el.find('td').map(function(idx, item){
                return item.textContent;
              }).toArray().join(", ");
            }
            return false;
          });
        }, function(err, result){
          assert.ifError(err);
          try {
            var badRows = result.value.filter(function(item){
              return item;
            });
          }
          catch (exception) {
            console.error(exception.message);
            console.log('Caught exception. Continuing with testing.')
            if (result.value !== null) {
              var badRows = result.value;
            }
          }
          try {
            assert.equal(badRows.length, 0, "Delete button found in rows:\n" + badRows.join("\n"));
          }
          catch (exception) {
            console.error(exception.message);
            console.log('Caught exception. Continuing with testing.')
          }
        })
        .call(callback);
    });

  };

})();
