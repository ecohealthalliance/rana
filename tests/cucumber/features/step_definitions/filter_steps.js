//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = require("underscore");

  module.exports = function () {

    this.Given(/^there is a report with "([^"]*)" "([^"]*)" in the database$/,
    function (property, value, callback) {
      var that = this;
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
      // Parse array values
      if (value.match(/\[.*\]/)) {
        value = value.replace(/\[|\]|\'/g, '').split(', ')
      }
      report[property] = value;
      this.addReports([report], function(err){
        assert.ifError(err);
        that.browser
        .waitForReport(report)
        .call(callback);
      });
    });
    
    this.When(/^I add a( second)? filter where "([^"]*)" is "([^"]*)"$/,
    function (second, property, value, callback) {
      var that = this;
      this.browser
      .isVisible('#filter-panel', function(err, isVisible) {
        assert.ifError(err);
        if (!isVisible) {
          that.browser
          .click('.toggle-filter')
          .waitForVisible('#filter-panel');
        }
        var currentIdx = second ? '1' : '0';

        if (second) {
          that.browser
          .click(".autoform-add-item");
        }
        
        var propKey = "filters." + currentIdx + ".property";
        var predKey = "filters." + currentIdx + ".predicate";
        var valKey = "filters." + currentIdx + ".value";
        that.browser
        .selectByValue('select[data-schema-key="' + propKey + '"]', property)
        .selectByValue('select[data-schema-key="' + predKey + '"]', "=")
        .setValue('input[data-schema-key="' + valKey + '"]', value)
        .click('button[type="submit"]')
        .pause(500)
        .call(callback);
      });
    });
    
    this.When(/^I remove the filters$/, function (callback) {
      this.browser
      .click(".clear")
      .call(callback);
    });
  };

})();