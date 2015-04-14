//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.When(/^I click on a report location marker$/,
    function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });

    this.Then(/^I should see a popup with information from the report$/,
    function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-popup-content')
        .getText('.leaflet-popup-content', function(err, value){
          assert(!err);
          var props = [
            'date',
            'type of population',
            'vertebrate classes',
            'species affected name',
            'number of individuals involved'
          ];
          for(var i=0;i<props.length;i++) {
            var prop = props[i];
            assert(RegExp(prop, "i").test(value), "Missing Property: " + prop);
          }
        }).call(callback);
    });

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
      .elements(".autoform-array-item", function(err, resp){
        assert.ifError(err);
        var currentIdx = resp.value.length;
        var propKey = "filters." + currentIdx + ".property";
        var predKey = "filters." + currentIdx + ".predicate";
        var valKey = "filters." + currentIdx + ".value";
        helper.world.browser
        .click(".autoform-add-item")
        .pause(200)
        .selectByValue('select[data-schema-key="' + propKey + '"]', property)
        .selectByValue('select[data-schema-key="' + predKey + '"]', "=")
        .setValue('input[data-schema-key="' + valKey + '"]', value)
        .click('button[type="submit"]')
        .call(callback);
      });
    });

    this.Then(/^I should see (\d+) reports?$/, function (number, callback) {
      helper.world.browser
      .waitForExist(".leaflet-marker-icon")
      .elements(".leaflet-marker-icon", function(err, resp){
        assert.ifError(err);
        assert.equal(resp.value.length, parseInt(number));
      })
      .call(callback);
    });

    this.When(/^I group the reports by "([^"]*)"$/,
    function (property, callback) {
      helper.world.browser
      .selectByValue('#group-by', property)
      .call(callback);
    });

    this.Then(/^I should see (\d+) pins with different colors?$/, function (number, callback) {
      helper.world.browser
      .waitForExist(".leaflet-marker-icon")
      .execute(function(){
        return $(".leaflet-marker-icon > :first-child")
          .toArray()
          .map(function(el){
            return $(el).css("background-color");
          });
      }, function(err, resp){
        assert.ifError(err);
        var colors = _.uniq(resp.value);
        assert.equal(colors.length, parseInt(number));
      })
      .call(callback);
    });

    this.When(/^I remove the filters$/, function (callback) {
      helper.world.browser
      .click(".reset")
      .call(callback);
    });
  };

})();
