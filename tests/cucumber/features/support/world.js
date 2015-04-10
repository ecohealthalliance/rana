(function () {

  'use strict';

  var assert = require('assert');

  module.exports = function () {

    var helper = this;

    var _ = Package["underscore"]._;
    var path = require('path');

    this.getAppDirectory = function () {
      var outPath = process.cwd();
      while(path.basename(outPath) !== ".meteor") {
        assert(outPath.length > 1);
        outPath = path.join(outPath, '..');
      }
      return path.join(outPath, '..');
    };

    this.World = function (next) {

      helper.world = this;

      helper.world.cucumber = Package['xolvio:cucumber'].cucumber;

      var options = {
        host: 'localhost',
        port: 4444,
        desiredCapabilities: {
          browserName: 'chrome'
        }
      };

      Package['xolvio:webdriver'].wdio.getChromeDriverRemote(options, function (browser) {
        helper.world.browser = browser;

        browser.addCommand("mustExist", function(selector, callback){
          browser.waitForExist(selector, function(err, exists){
            assert.ifError(err);
            assert(exists, "Could not find " + selector);
          }).call(callback);
        });

        browser.addCommand("getMyReports", function(baseQuery, callback) {
          browser
          .timeoutsAsyncScript(2000)
          .executeAsync(function(baseQuery, done){
            Meteor.subscribe("reports");
            Tracker.autorun(function(){
              var query = _.extend(baseQuery, {
                'createdBy.userId': Meteor.userId()
              });
              var reports = collections.Reports.find(query);
              if(reports.count() > 0) done(reports.fetch());
            });
            window.setTimeout(done, 2000);
          }, baseQuery, _.once(callback));
        });
        
        browser.addCommand("waitForReport", function(report, callback) {
          // This turns documents into Mongo queries that use JSON paths.
          // Nested objects queries were failing here,
          // but strangely I've been able to use in my browser console.
          function objectToQuery(obj, prefix){
            if(!prefix) prefix = [];
            var returnVal = {};
            Object.keys(obj).forEach(function(key){
              var value = obj[key];
              if(_.isArray(value)) {
                if(value.length > 0) {
                  if(value.some(function(item){
                    return _.isObject(item);
                  })) {
                    throw new Error("waitForReport does not support reports with object arrays.");
                  }
                  returnVal[prefix.concat(key).join('.')] = { $all: value };
                }
              } else if(_.isObject(value)) {
                _.extend(returnVal, objectToQuery(value, prefix.concat([key])));
              } else {
                returnVal[prefix.concat(key).join('.')] = value;
              }
            });
            return returnVal;
          }
          browser
          .timeoutsAsyncScript(3000)
          .executeAsync(function getReport(query, done){
            Meteor.subscribe('reports');
            Tracker.autorun(function(){
              var report = collections.Reports.findOne(query);
              if(report) done(report);
            });
            setTimeout(function(){
              done({
                error: "Query:\n" +
                  JSON.stringify(query, 2,2) +
                  "Reports in the DB:\n" +
                  JSON.stringify(collections.Reports.find().fetch(), 2,2)
              });
            }, 2000);
          }, objectToQuery(report), _.once(function(err, ret){
            assert.ifError(err);
            assert.ifError(ret.value.error, "Report not found");
            callback();
          }));
        });

        browser.addCommand("getTextWhenVisible", function(selector, callback) {
          browser
          .waitForText(selector, function(err, exists){
            assert.ifError(err);
            assert(exists, "Text does not exist");
          })
          .getText(selector, callback);
        });
        
        browser.addCommand("clickWhenVisible", function(selector, callback) {
          browser
          .waitForExist(selector, 1000, function(err, exists){
            assert.ifError(err);
            if(!exists) {
              browser.saveScreenshot(
                helper.getAppDirectory() +
                "/tests/screenshots/missing selector - " +
                helper.world.scenario.getName() +
                ".png"
              );
            }
            assert(exists, selector + " does not exist");
          })
          .click(selector, callback);
        });

        browser.addCommand("checkValue", function(query, expectedValue, callback) {
          browser
          .getValue(query, function(err, value){
            assert(!err);
            assert.equal(value, expectedValue);
          })
          .call(callback);
        });

        browser.addCommand("generateFormData", function(schemaName, callback) {
          browser
          .mustExist('.form-group')
          .execute(function(schemaName) {
            return AutoForm.Fixtures.getData(collections[schemaName].simpleSchema());
          }, schemaName, function(err, res) {
            assert.ifError(err);
            callback(res.value);
          });
        });
        
        browser.addCommand("setFormFields", function(formData, schemaName, callback) {
          function flattenObjectToSchema(obj, prefix){
            if(!prefix) prefix = [];
            var returnVal = {};
            Object.keys(obj).forEach(function(key){
              var value = obj[key];
              if(_.isArray(value)) {
                returnVal[prefix.concat(key).join('.')] = value;
              } else if(_.isObject(value)) {
                _.extend(returnVal, flattenObjectToSchema(value, prefix.concat([key])));
              } else {
                returnVal[prefix.concat(key).join('.')] = value;
              }
            });
            return returnVal;
          }
          formData = flattenObjectToSchema(formData);
          browser
          .mustExist('.form-group')
          .call(function(){
            var schema = collections[schemaName].simpleSchema().schema();
            _.each(formData, function (value, key) {
              if(key === "specifyOtherRanavirusSampleTypes") return;
              if(!schema[key]) {
                console.log("Bad key: "+ key);
                return;
              }
              if (key === 'studyId') {
                // studyId is designated as a select via options passed in via
                // a helper, so it's not in the schema and can't be detected here.
                browser.selectByValue('select[data-schema-key="' + key + '"]', value);
              } else if (schema[key].autoform && schema[key].autoform.rows) { //textarea
                browser.setValue('textarea[data-schema-key="' + key + '"]', value);
              } else if (schema[key].type === Boolean) {
                browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
              } else if (schema[key].type === Array) {
                _.each(value, function (element) {
                  if(!_.isString(element)) {
                    console.log("WARNING: Type is not supported for key: " + key);
                    return;
                  }
                  browser.click('div[data-schema-key="' + key + '"] input[value="' + element + '"]');
                });
              } else if (
                schema[key].autoform &&
                schema[key].autoform.afFieldInput &&
                (schema[key].autoform.options || schema[key].autoform.afFieldInput.options) &&
                schema[key].autoform.afFieldInput.noselect
              ) { // radio
                browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
              } else if (
                schema[key].autoform &&
                schema[key].autoform.afFieldInput &&
                (schema[key].autoform.options || schema[key].autoform.afFieldInput.options)
              ) { //select
                browser.selectByValue('select[data-schema-key="' + key + '"]', value);
              } else if (
                  schema[key].type === String ||
                  schema[key].type === Number
              ) {
                browser.setValue('input[data-schema-key="' + key + '"]', value);
              } else if (schema[key].type === Date) {
                // This doesn't work
                // https://github.com/watir/watir-webdriver/issues/295
                // browser.addValue('input[data-schema-key="' + key + '"]', value.split("T")[0].split("-").reverse().join("/"));
              } else if (schema[key].type === Object) {
                _.each(value, function (subValue, subKey) {
                  var schemaKey = key + '.' + subKey;
                  browser.setValue('input[data-schema-key="' + schemaKey + '"]', subValue);
                });
              } else {
                var error = 'unknown type in schema: ' + schema[key] + ' for key: ' + key;
                throw new Error(error);
              }
            });

            callback();
          });
        });

        // Useful for keeping the Chrome window open so you can inspect things
        // in the console or view the screen at a certain point.
        browser.addCommand("holdWindowOpen", function() {
          browser
          .timeoutsAsyncScript(1000000);
        });

        browser.call(next);
      });

    };

  };

})();
