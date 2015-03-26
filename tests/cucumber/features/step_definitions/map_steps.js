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
          geo: {
            type: 'Point',
            coordinates: [ 121.55189514218364, 25.046919772516173 ]
          }
        }
      };
      report[property] = value;
      helper.addReports([report], function(err){
        assert.ifError(err);
        helper.world.browser
        .executeAsync(function(expectedReport, done){
          delete expectedReport['createdBy'];
          Meteor.subscribe('reports');
          Tracker.autorun(function(){
            var report = collections.Reports.findOne();
            if(report) done(report);
          });
          window.setTimeout(done, 2000);
        }, report, _.once(function(err, ret){
          assert.ifError(err);
          assert(ret.value, "No reports in the database");
          callback();
        }));
      });
    });
    
    this.When(/^I add a filter for the property "([^"]*)" and value "([^"]*)"$/,
    function (property, value, callback) {
      var propKey = "filters.0.property";
      var valKey = "filters.0.value";
      helper.world.browser
      .click(".autoform-add-item")
      .pause(200)
      .selectByValue('select[data-schema-key="' + propKey + '"]', property)
      .setValue('input[data-schema-key="' + valKey + '"]', value)
      .click('button[type="submit"]')
      .call(callback);
    });
    
    this.Then(/^I should see (\d+) reports?$/, function (number, callback) {
      helper.world.browser
      .waitForExist(".leaflet-marker-icon")
      .elements(".leaflet-marker-icon", function(err, resp){
        assert.ifError(err);
        assert.equal(resp.value.length, number);
      })
      .call(callback);
    });
    
    this.When(/^I remove the filters$/, function (callback) {
      // Write code here that turns the phrase above into concrete actions
      helper.world.browser
      .click(".reset")
      .call(callback);
    });
  };

})();
