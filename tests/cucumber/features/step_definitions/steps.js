//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');

  var _ = Package["underscore"]._;

  module.exports = function () {

    var helper = this;

    this.visit = function (path, callback) {
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + path)
      .waitForExist(".container", function(err, exists){
        assert(!err);
        assert(exists, "Could not find container element");
      })
      .getText(".container", function(err, text){
        assert(!err);
        var regexString = "no route on the client or the server for url"
          .split(" ")
          .join("\\s+");
        assert(!RegExp(regexString, "i").test(text), "Missing page");
      }).call(callback);
    };
    this.Given('I am on the "$path" page', this.visit);
    this.When('I navigate to the "$path" page', this.visit);

    this.Then('I should be redirected to the "$path" page', function (path, callback) {
      helper.world.browser
      .pause(4000)
      .url(function (err, result) {
        assert.ifError(err);
        if(result.value.slice(-path.length) !== path) {
          helper.world.browser.saveScreenshot(
            helper.getAppDirectory() +
            "/tests/screenshots/redirect failure - " +
            helper.world.scenario.getName() +
            ".png"
          );
        }
        assert.equal(result.value.slice(-path.length), path);
      }).call(callback);
    });

    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      helper.world.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.When(/^I click submit$/, function (callback) {
      helper.world.browser
        .saveScreenshot(
          helper.getAppDirectory() +
          "/tests/screenshots/submit - " +
          helper.world.scenario.getName() +
          ".png"
        )
        .click('[type=submit]')
        .call(callback);
    });

    this.When('I click the "$buttonName" button',
    function (buttonName, callback) {
      var buttonNameToSelector = {
        "Columns" : ".reactive-table-columns-dropdown button",
        "Remove" : "a.remove"
      };
      var selector = buttonName;
      if(buttonName in buttonNameToSelector) {
        selector = buttonNameToSelector[buttonName];
      }
      helper.world.browser
        .click(selector)
        .call(callback);
    });

    this.When('I type "$word" into the prompt',
    function (word, callback) {
      helper.world.browser.alertText(word)
        .call(callback);
    });

    this.When('I accept the prompt',
    function (callback) {
      helper.world.browser.alertAccept()
      .call(callback);
    });

    this.When('I dismiss the toast',
    function (callback) {
      helper.world.browser.clickWhenVisible('.toast').pause(1000).call(callback);
    });

    // This is broken. Webdriver complains that another element would receive the click.
    this.When('I click on the edit link in the toast',
    function (callback) {
      helper.world.browser
        .click('.toast-message a')
        .call(callback);
    });

    this.Then(
      /^the database should( not)? have a report with the (name|email) "([^"]*)"$/,
    function (shouldNot, prop, value, callback) {
      var query = {};
      query[prop] = value;
      helper.world.browser
      .executeAsync(function(query, done){
        Meteor.subscribe("reports");
        Tracker.autorun(function(){
          var reports = collections.Reports.find(query);
          if(reports.count() > 0) done(reports.fetch());
        });
        window.setTimeout(done, 2000);
      }, query, _.once(function(err, ret){
        assert.ifError(err);
        if(shouldNot) {
          assert(!ret.value, 'Report found');
        } else {
          assert.equal(ret.value.length, 1, 'Incorrect number of reports');
        }
      })).call(callback);
    });

    this.Given(/^there is a report( with a geopoint)?( created by someone else)? in the database$/,
    function(withGeo, someoneElse, callback) {
      var report = {
        studyId: 'fakeid',
        consent: true,
        contact: {name: 'Test User', email: 'test@foo.com'},
        dataUsePermissions: "Share full record"
      };
      if(withGeo) {
        report["eventLocation"] = {
          source: 'LonLat',
          northing: 1,
          easting: 2,
          zone: 3,
          degreesLon: -170,
          minutesLon: 30,
          secondsLon: 40.58647497889751,
          degreesLat: 0,
          minutesLat: 0,
          secondsLat: 0.032469748221482304,
          country: 'USA',
          geo: {
            type: 'Point',
            coordinates: [ 121.55189514218364, 25.046919772516173 ]
          }
        };
      }
      if(someoneElse) {
        report['createdBy'] = {
          userId: "fakeId",
          name: "Someone Else"
        };
      }
      helper.addReports([report], function(err){
        assert.ifError(err);
        helper.world.browser
        .waitForReport(report)
        .call(callback);
      });
    });

    this.Then("there should be no delete button for the report by someone else",
    function(callback){
      helper.world.browser
        .mustExist('.reactive-table tr')
        .execute(function() {
          return $('.reactive-table tr').map(function(idx, element){
            var $el = $(element);
            var someoneElse = /Someone Else/.test(
              $el.find('td[class="createdBy.name"]').text()
            );
            var hasDelete = Boolean($el.find(".remove-form").length);
            if(someoneElse && hasDelete) {
              return $el.find('td').map(function(idx, item){
                return item.textContent;
              }).toArray().join(", ");
            }
            return false;
          });
        }, function(err, result){
          assert.ifError(err);
          var badRows = result.value.filter(function(item){
            return item;
          });
          assert.equal(badRows.length, 0, "Delete button found in rows:\n" + badRows.join("\n"));
        })
        .call(callback);
    });

    this.Given(/^there are no reports in the database$/,
    function (callback) {
      helper.resetTestDB([], callback);
    });

    this.When("I delete the report", function(callback){
      helper.world.browser
        .clickWhenVisible(".remove-form")
        .alertText("delete", assert.ifError)
        .alertAccept(assert.ifError)
        .call(callback);
    });

    this.Then(/^I should( not)? see the text "([^"]*)"/,
    function (shouldNot, text, callback) {

      helper.world.browser
        .waitForText('body')
        .getText('body', function(err, bodyText){
          assert(!err);
          if (shouldNot) {
            assert(
              !(new RegExp(text, "i").test(bodyText)),
              '"' + text + '" in "' + bodyText + '"'
            );
          } else {
            assert(
              new RegExp(text, "i").test(bodyText),
              '"' + text + '" not in "' + bodyText + '"'
            );
          }
        }).call(callback);
    });

    this.Then(/^I should be on the "([^"]*)" page$/,
    function (page, callback) {

      helper.world.browser.pause(2000).
      url(function(err, res) {
        assert(!err);
        assert.equal(res.value, 'http://localhost:5000/' + page);
      }).call(callback);

    });

    this.When('I click on the edit button',
    function(callback){
      helper.world.browser
      .click('.reactive-table td.controls .btn-edit')
      .call(callback);
    });

    this.When('I click on the edit profile button',
    function(callback){
      helper.world.browser
      .click('.edit-profile')
      .call(callback);
    });

  };

})();
