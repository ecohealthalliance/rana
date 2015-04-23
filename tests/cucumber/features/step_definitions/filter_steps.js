//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.Given(/^there is a report with "([^"]*)" "([^"]*)" in the database$/,
    function (property, value, callback) {
      var report = {
        eventLocation: {
          source: 'LonLat',
          northing: 1,
          easting: 2,
          zone: 3,
          degreesLon: -170,
          minutesLon: 30,
          secondsLon: 40.58647497889751,
          degreesLat: 0,
          minutesLat: 0,
          secondsLat: 0.032469748221482304,
          geo: {
            type: 'Point',
            coordinates: [ 121.55189514218364, 25.046919772516173 ]
          },
          country: 'USA'
        }
      };
      report[property] = value;
      helper.addReports([report], function(err){
        assert.ifError(err);
        helper.world.browser
        .waitForReport(report)
        .call(callback);
      });
    });
    
    this.When(/^I add a filter where "([^"]*)" is "([^"]*)"$/,
    function (property, value, callback) {
      helper.world.browser
      .isVisible('#filter-panel', function(err, isVisible) {
        assert.ifError(err);
        if (!isVisible) {
          helper.world.browser
          .click('.toggle-filter')
          .waitForVisible('#filter-panel')
        }

        helper.world.browser
        .elements(".autoform-array-item", function(err, resp){
          assert.ifError(err);
          var currentIdx = resp.value.length - 1;
          var propKey = "filters." + currentIdx + ".property";
          var predKey = "filters." + currentIdx + ".predicate";
          var valKey = "filters." + currentIdx + ".value";
          helper.world.browser
          .click(".autoform-add-item")
          .selectByValue('select[data-schema-key="' + propKey + '"]', property)
          .selectByValue('select[data-schema-key="' + predKey + '"]', "=")
          .setValue('input[data-schema-key="' + valKey + '"]', value)
          .click('button[type="submit"]')
          .call(callback);
        });
      });
    });
    
    this.When(/^I remove the filters$/, function (callback) {
      helper.world.browser
      .click(".clear")
      .call(callback);
    });
  };

})();