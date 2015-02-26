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
      connection.call('/fixtures/resetDB', reports, function(err, res) {
        if (err) {
          console.log("DDP Error", err);
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
        //Somehow, past logins are being persisted
        //so I make sure they are signed out here.
        executeAsync(function(done){
          if("Meteor" in window) {
            Meteor.logout(function(err){
              done(err);
            });
          } else {
            done("No Meteor");
          }
        }, function(err, err2){
          if(err) {
            console.log("Scenario cleanup error:", err);
            throw new Error(err);
          }
        }).
        end().
        call(next);
    });

  };

})();