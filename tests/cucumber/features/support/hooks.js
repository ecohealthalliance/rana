(function () {

  'use strict';

  module.exports = function () {

    var helper = this;

    var _resetTestDB = Meteor.bindEnvironment(function(next) {
      var connection = DDP.connect(helper.world.cucumber.mirror.host);
      connection.call('/fixtures/resetDB', function(err) {
        if (err) {
          console.log(err);
          next.fail('Error in /fixtures/resetDB DDP call to ' + helper.world.cucumber.mirror.host, err);
        } else {
          next();
        }
        connection.disconnect();
      });
    });

    this.Before(function () {
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

    this.After(function () {
      var world = helper.world;
      var next = arguments[arguments.length - 1];
      world.browser.
        end().
        call(next);
    });

  };

})();