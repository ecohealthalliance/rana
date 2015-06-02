//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.Then(/the database should have (\d+) reports linked to my account/,
    function (number, callback) {
      helper.world.browser
      .getMyReports({}, function(err, ret){
        assert.ifError(err);
        assert(ret);
        assert.equal(ret.length, parseInt(number), 'Incorrect number of reports ' + ret.length + '; should be ' + number);
        callback();
      });
    });

    this.When("I register an account", function(callback){
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + "grrs/sign-in")
      .waitForExist("#at-signUp", 3000, function(err, exists){
        assert.ifError(err);
        if(!exists) {
          helper.world.browser.getHTML("body", console.log.bind(console));
          assert(exists, "Register button missing");
        }
      })
      .click("#at-signUp", assert.ifError)
      .waitForExist(".form-control")
      .setValue('#at-field-email', 'test' + Math.floor(Math.random()*100) + '@user.com')
      .setValue('#at-field-password', 'testuser')
      .setValue('#at-field-password_again', 'testuser')
      .setValue('#at-field-name', 'Registration Test User')
      .submitForm('#at-field-email', assert.ifError)
      .waitForExist(".form-control", 1000, true, function(err, dne){
        assert.ifError(err);
        assert(dne);
      })
      .call(callback);
    });

    this.When(/^I log in(?: as (admin|pending))?$/, function(user, callback){
      if (! user) {
        user = 'test';
      }
      var emails = {
        admin: 'admin@admin.com',
        test: 'test@test.com',
        pending: 'pending@test.com'
      }
      var passwords = {
        admin: 'adminuser',
        test: 'testuser',
        pending: 'pendinguser'
      }
      var email = emails[user];
      var password = passwords[user];
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + "grrs/sign-in")
      .waitForExist(".at-pwd-form", function(err, exists){
        assert.ifError(err);
        assert(exists);
      })
      .setValue('#at-field-email', email)
      .setValue('#at-field-password', password)
      .submitForm('#at-field-email', function(err){
        assert.ifError(err);
      })
      .waitForExist(".at-pwd-form", 1000, true, function(err, dne){
        assert.ifError(err);
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

    this.Given(/I have logged in( as admin)?/, function (admin, callback) {
      var email = admin ? "admin@admin.com" : "test@test.com";
      var password = admin ? "adminuser" : "testuser";
      helper.world.browser.executeAsync(function (email, password, done) {
        Meteor.loginWithPassword(email, password, function (err) {
          if (err) return done();
          done(Meteor.userId());
        });
      }, email, password, function (err, ret) {
        assert.ifError(err);
        assert(ret.value);
      }).call(callback);
    });

    this.When("I log out",
    function (callback) {
      helper.world.browser
        .click('.admin-settings')
        .click('.sign-out')
        .pause(500)
        .call(callback);
    });

    this.Then(/I am( not)? logged in/,
    function(amNot, callback){
      helper.world.browser
      .execute(function(){
        return Meteor.userId();
      }, function(err, ret){
        assert.ifError(err);
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
      .waitForExist(".at-error", function(err, exists){
        assert.ifError(err);
        assert(exists, "Could not find container element");
      })
      .getText(".at-error", function(err, text){
        assert.ifError(err);
        var regexString = "must be logged in"
          .split(" ")
          .join("\\s+");
        assert(RegExp(regexString, "i").test(text), "No login message");
      }).call(callback);
    });

  };

})();
