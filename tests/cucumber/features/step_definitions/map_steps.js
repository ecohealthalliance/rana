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
    
    this.Then(/^I should see (\d+) reports? on the map$/, function (number, callback) {
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
  };

})();
