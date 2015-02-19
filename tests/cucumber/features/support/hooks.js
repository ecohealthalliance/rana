//Documentation for writing hooks:
//https://github.com/cucumber/cucumber-js
(function () {

  'use strict';

  module.exports = function () {

    var helper = this;

    var _resetTestDB = Meteor.bindEnvironment(function(next) {
      var doneCalled = false;
      var done = function(err){
        if(doneCalled) return next.fail("Error: Done called twice.");
        doneCalled = true;
        if(err) return next.fail(err);
        next();
      };
      setTimeout(function(){
        if(!doneCalled) done("Timeout");
      }, 1000);
      var connection = DDP.connect(helper.world.cucumber.mirror.host);
      connection.call('/fixtures/resetDB', function(err) {
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
          _resetTestDB(next);
        });
        
    });
    
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

    this.After(function (scenario, callback) {
      var world = helper.world;
      var next = arguments[arguments.length - 1];
      console.log(scenario.getName() + " after");
      world.browser.
        end().
        call(next);
    });

  };

})();