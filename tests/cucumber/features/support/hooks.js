//Documentation for writing hooks:
//https://github.com/cucumber/cucumber-js
(function () {

  'use strict';
  
  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.resetTestDB = Meteor.bindEnvironment(function(reports, next) {
      var done = _.once(next);
      setTimeout(function(){
        done("Timeout");
      }, 1000);
      var connection = DDP.connect(helper.world.cucumber.mirror.host);
      connection.call('/fixtures/resetDB', reports, function(err) {
        if (err) {
          console.log(err);
          done('Error in /fixtures/resetDB DDP call to ' + helper.world.cucumber.mirror.host);
        } else {
          done();
        }
        connection.disconnect();
      });
    });

    this.Before(function() {
      var world = helper.world;
      var next = arguments[arguments.length - 1];
      world.browser.
        init().
        setViewportSize({
          width: 1280,
          height: 1024
        }).
        call(function(){
          helper.resetTestDB([], next);
        });
    });
/*
    // This is useful for debugging in the console, but
    // it is causing the html reporter to print out "Around undefined"
    // and print steps in the wrong order.
    this.Around(function(scenario, runScenario) {
      console.log("");
      if("getName" in scenario) {
        console.log(scenario.getName(), "(" + scenario.getUri() + ":" + scenario.getLine() + ")");
      } else {
        console.log("Scenario with no name");
      }
      runScenario(function(callback) {
        console.log("done");
        callback();
      });
    });
*/
    this.After(function (scenario, callback) {
      var world = helper.world;
      var next = arguments[arguments.length - 1];
      world.browser.
        end().
        call(next);
    });

  };

})();