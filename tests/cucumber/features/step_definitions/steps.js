//For browser API documentaiton see: http://webdriver.io/api/
(function () {

  'use strict';

  var assert = require('assert');
  var _ = require("underscore");
  var url = require("url");

  module.exports = function () {
    this.visit = function (path, callback) {
      this.browser
      .url(url.resolve(process.env.ROOT_URL, path))
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

    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      this.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.When(/^I click submit(?: again)?$/, function (callback) {
      this.browser
        .mustExist('[type=submit]')
        .click('[type=submit]')
        .pause(200)
        // .saveScreenshot(
        //   this.getAppDirectory() +
        //   "/tests/screenshots/submit - " +
        //   this.scenario.getName() +
        //   ".png"
        // )
        .call(callback);
    });

    this.When('I click the "$buttonName" button',
    function (buttonName, callback) {
      var buttonNameToSelector = {
        "Columns" : ".reactive-table-columns-dropdown button",
        "Remove" : "a.remove",
        "Edit Report" : ".toast-message a"
      };
      var selector = buttonName;
      if(buttonName in buttonNameToSelector) {
        selector = buttonNameToSelector[buttonName];
      }
      this.browser
        .mustExist(selector)
        .click(selector)
        .call(callback);
    });

    this.When('I type "$word" into the prompt',
    function (word, callback) {
      this.browser.alertText(word)
        .call(callback);
    });

    this.When('I accept the prompt',
    function (callback) {
      this.browser.alertAccept()
      .call(callback);
    });

    this.When('I dismiss the toast',
    function (callback) {
      this.browser.clickWhenVisible('.toast').pause(1000).call(callback);
    });

    // This is broken. Webdriver complains that another element would receive the click.
    this.When('I click on the edit link in the toast',
    function (callback) {
      this.browser
        .click('.toast-message a')
        .call(callback);
    });

    this.Then(
      /^the database should( not)? have a report with the (name|email) "([^"]*)"$/,
    function (shouldNot, prop, value, callback) {
      var query = {};
      query[prop] = value;
      this.checkForReports(query, function (reports) {
        if (shouldNot) {
          assert(!reports.length, "Report found");
        } else {
          assert.equal(reports.length, 1, "Incorrect number of reports");
        }
        callback();
      });
    });

    this.Given(/^there is a report( with a geopoint)?( created by someone else)? in the database$/,
    function(withGeo, someoneElse, callback) {
      var that = this;
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
      this.addReports([report], function(err){
        assert.ifError(err);
        that.browser
        .waitForReport(report)
        .call(callback);
      });
    });

    this.Given(/^there is a study( created by someone else)? in the database$/,
    function(someoneElse, callback) {
      var study = {
        consent: true,
        contact: {name: 'Test User', email: 'test@foo.com'},
        dataUsePermissions: "Share full record"
      };
      if(someoneElse) {
        study['createdBy'] = {
          userId: "fakeId",
          name: "Someone Else"
        };
      }
      var that = this;
      this.addStudies([study], function(err){
        assert.ifError(err);
        that.browser
        .waitForStudy(study)
        .call(callback);
      });
    });

    // Currently this is just used for benchmarking tests that aren't included
    // in the main branch of the repository.
    this.Given(/^there are (\d+) reports in the database$/,
    function(number, callback) {
      number = parseInt(number, 10);
      var reports = _.range(number).map(function(){
        return {
          studyId: 'fakeid',
          consent: true,
          contact: {name: 'Test User', email: 'test@foo.com'},
          dataUsePermissions: "Share full record",
          // Random data to simulate large reports
          speciesNotes: _.range(200).map(Math.random).join(' '),
          eventLocation: {
            source: 'LonLat',
            // These fields are not used in the many reports test,
            // so we do not need to generate correct values for them.
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
              coordinates: [
                Math.random() * 360 - 180,
                Math.random() * 180 - 90
              ]
            }
          }
        };
      });
      this.addReports(reports, function(err){
        assert.ifError(err);
        callback();
      }, 200 * number);
    });

    this.Given(/^there are no reports in the database$/,
    function (callback) {
      this.resetTestDB([], callback);
    });

    this.Then(/^I should( not)? see the text "([^"]*)"/,
    function (shouldNot, text, callback) {

      this.browser
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

    this.Then('I should be on the "$path" page', function (path, callback) {
      var that = this;
      this.browser
      .pause(4000)
      .url(function (err, result) {
        assert.ifError(err);
        if(result.value.slice(-path.length) !== path) {
          that.browser.saveScreenshot(
            that.getAppDirectory() +
            "/tests/screenshots/redirect failure - " +
            that.scenario.getName() +
            ".png"
          );
        }
        assert.equal(result.value.slice(-path.length), path);
      }).call(callback);
    });


    this.When('I click on the edit button',
    function(callback){
      this.browser
      .click('.reactive-table td.controls .btn-edit')
      .call(callback);
    });

    this.When('I click on the admin settings button',
    function(callback){
      this.browser
      .click('.admin-settings')
      .call(callback);
    });

    this.When('I click on the view button',
    function(callback){
      this.browser
      .click('.reactive-table td.controls .btn-view')
      .call(callback);
    });

    this.When('I click on the profile button',
    function(callback){
      this.browser
      .click('.profile')
      .call(callback);
    });

    this.When('I click the Add a report button',
    function(callback){
      this.browser
      .click('.add-report')
      .call(callback);
    });

  };

})();
