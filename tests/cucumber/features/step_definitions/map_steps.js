//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var _ = require("underscore");

  module.exports = function () {

    this.When(/^I click on a report location marker$/,
    function (callback) {
      this.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });

    this.Then(/^I should see a popup with information from the report$/,
    function (callback) {
      this.browser
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

    this.Then(/^I should see (\d+) reports? on the map$/, function (number, callback) {
      this.browser
      .waitForExist(".leaflet-marker-icon", 10000)
      .elements(".leaflet-marker-icon", function(err, resp){
        assert.ifError(err);
        assert.equal(resp.value.length, parseInt(number, 10));
      })
      .call(callback);
    });

    this.When(/^I group the reports by "([^"]*)"$/,
    function (property, callback) {
      this.browser
      .click('.toggle-group')
      .waitForVisible('#group-by')
      .selectByValue('#group-by', property)
      .call(callback);
    });

    this.Then(/^I should see (\d+) pins with different colors?$/, function (number, callback) {
      this.browser
      .waitForExist(".leaflet-marker-icon")
      .execute(function(){
        return $(".leaflet-marker-icon > :first-child")
          .toArray()
          .map(function(el){
            return $(el).css("color");
          });
      }, function(err, resp){
        assert.ifError(err);
        var colors = _.uniq(resp.value);
        assert.equal(colors.length, parseInt(number));
      })
      .call(callback);
    });
  };

})();
