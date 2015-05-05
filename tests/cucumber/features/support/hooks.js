//Documentation for writing hooks:
//https://github.com/cucumber/cucumber-js
(function () {

  'use strict';

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.DDPCall = Meteor.bindEnvironment(function(route, parameter, next, timeout) {
      if(!timeout) {
        timeout = 1000;
      }
      var done = _.once(next);
      setTimeout(function(){
        done("Timeout");
      }, timeout);
      var connection = DDP.connect(helper.world.cucumber.mirror.host);
      connection.call(route, parameter, function(err, res) {
        connection.disconnect();
        if (err) {
          console.log("DDP Error", err);
          done('Error in ' + route + ' DDP call to ' + helper.world.cucumber.mirror.host);
        } else {
          done(err, res);
        }
      });
    });

    this.resetTestDB = function(reports, next) {
      this.DDPCall('/fixtures/resetDB', reports, next);
    };

    this.addReports = function(reports, next, timeout) {
      this.DDPCall('/fixtures/addReports', reports, next, timeout);
    };

    this.addStudies = function(studies, next, timeout) {
      this.DDPCall('/fixtures/addStudies', studies, next, timeout);
    };

    this.checkForReports = function (reportQuery, next) {
      this.DDPCall('/fixtures/checkForReports', reportQuery, next);
    };

    this.checkForStudies = function (studyQuery, next) {
      this.DDPCall('/fixtures/checkForStudies', studyQuery, next);
    };

    this.Before(function(scenario) {
      var world = helper.world;
      world.scenario = scenario;
      var next = arguments[arguments.length - 1];
      world.browser.
        init().
        setViewportSize({
          width: 1280,
          height: 1024
        }).
        timeoutsAsyncScript(2000).
        url(helper.world.cucumber.mirror.rootUrl).
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
