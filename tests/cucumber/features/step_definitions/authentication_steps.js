//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.Then(/the database should( not)? have a report linked to my account/,
    function (shouldNot, query, callback) {
      helper.world.browser
      .getMyReports({}, function(err, ret){
        assert(!err);
        assert(ret.value);
        if(shouldNot) {
          assert(!ret.value, 'Report found');
        } else {
          assert.equal(ret.value.length, 1, 'Incorrect number of reports');
        }
      }).call(callback);
    });
    
    this.Then(/my reports without consent should(not)? be available/,
    function(shouldNot, callback){
      helper.world.browser
      .getMyReports({consent: false}, function(err, ret){
        assert(!err);
        if(shouldNot) {
          assert(!ret.value);
        } else {
          assert(ret.value);
          assert(ret.value.length > 1);
        }
      }).call(callback);
    });
    
    this.When("I register an account", function(callback){
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + "sign-in")
      //.getHTML("body", console.log.bind(console))
      .waitForExist("#at-signUp", 3000, function(err, exists){
        assert(!err);
        if(!exists) {
          helper.world.browser.getHTML("body", console.log.bind(console));
          assert(exists, "Register button missing");
        }
      })
      .click("#at-signUp", function(err){
        assert(!err);
      })
      .waitForExist(".form-control")
      .setValue('#at-field-email', 'test' + Math.floor(Math.random()*100) + '@user.com')
      .setValue('#at-field-password', 'testuser')
      .setValue('#at-field-password_again', 'testuser')
      .setValue('#at-field-name', 'Test User')
      .submitForm('#at-field-email', function(err){
        assert(!err);
      })
      .waitForExist(".form-control", 500, true, function(err, dne){
        assert(!err);
        assert(dne);
      })
      .call(callback);
    });
  
    this.When(/I log in/, function(callback){
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + "sign-in")
      .waitForExist(".form-control", function(err, exists){
        assert(!err);
        assert(exists);
      })
      .setValue('#at-field-email', "test@test.com")
      .setValue('#at-field-password', "testuser")
      .submitForm('#at-field-email', function(err){
        assert(!err);
      })
      .waitForExist(".form-control", 500, true, function(err, dne){
        assert(!err);
        assert(dne);
      })
      .call(callback);
    });
  
    this.Given(/I have not logged in/,
    function(callback){
      helper.world.browser.execute(function () {
        Meteor.logout();
      }).call(callback);
    });
    
    this.Given(/I have logged in/, function (callback) {
      helper.world.browser.executeAsync(function (done) {
        Meteor.loginWithPassword("test@test.com", "testuser", function (err) {
          if (err) return done();
          done(Meteor.userId());
        });
      }, function (err, ret) {
        assert(!err);
        assert(ret.value);
      }).call(callback);
    });
    
    this.When("I log out",
    function (callback) {
      helper.world.browser
        .click('.at-nav-button')
        .pause(500)
        .call(callback);
    });
    
    this.Then(/I am( not)? logged in/,
    function(amNot, callback){
      helper.world.browser
      .execute(function(){
        return Meteor.userId();
      }, function(err, ret){
        assert(!err);
        if(amNot) {
          assert.equal(ret.value, null, "Authenticated");
        } else {
          assert(ret.value, "Not authenticated");
        }
      }).call(callback);
    });
    
    this.Then("I will see a message that requires me to log in",
    function(callback) {
      helper.world.browser
      .waitForExist(".container", function(err, exists){
        assert(!err);
        assert(exists, "Could not find container element");
      })
      .getText(".container", function(err, text){
        assert(!err);
        var regexString = "must sign in"
          .split(" ")
          .join("\\s+");
        assert(RegExp(regexString, "i").test(text), "No login message");
      }).call(callback);
    });
    
  };

})();