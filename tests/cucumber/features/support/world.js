(function () {

  'use strict';

  var assert = require('assert');

  var nestedStringKey = function(key, obj) {
    return _(key.split('.')).reduce((function(obj, key) {
      return obj[key];
    }), obj);
  };

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
          .execute(function(){
            return Meteor.userId();
          }, function (err, ret) {
            assert.ifError(err);
            var query = _.extend(baseQuery, {
              'createdBy.userId': ret.value
            });
            helper.checkForReports(query, function (err, reports) {
              callback(err, reports);
            })
          });
        });

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

        browser.addCommand("waitForReport", function(report, callback) {
          var query = objectToQuery(report);
          helper.checkForReports(query, function (err, reports) {
            if (reports.length) {
              callback(reports[0]);
            } else {
              callback({
                error: "Query:\n" +
                  JSON.stringify(query, 2,2)
              });
            }
          });
        });

        browser.addCommand("waitForStudy", function(study, callback) {
          var query = objectToQuery(study);
          helper.checkForStudies(query, function (err, studies) {
            if (studies.length) {
              callback(studies[0]);
            } else {
              callback({
                error: "Query:\n" +
                  JSON.stringify(query, 2,2)
              });
            }
          });
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
              // Specify other fiels are not supported because they might be
              // hidden depending on what is selected
              if(key.indexOf("specifyOther") === 0) {
                console.log("WARNING: Specify other field ignored by setFormFields: " + key);
                return;
              }
              if(!schema[key]) {
                console.log("Bad key: "+ key);
                return;
              }
              // Don't set the hidden approval field that is based on user status
              if(key == 'approval') {
                return;
              }
              if (schema[key].autoform && schema[key].autoform.rows) { //textarea
                browser.setValue('textarea[data-schema-key="' + key + '"]', value);
              } else if (schema[key].type === Boolean) {
                // Hack to scroll past the review covering up the permissions
                // radio buttons
                browser.scroll(0, 4000)
                .click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
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
            // The browser input calls above do not block future calls to
            // browser methods, so a pause is used to wait for input to be entered.
            browser.pause(1000).call(callback);
          });
        });

        browser.addCommand("checkFormFields", function(formId, expectedValues, callback) {
          browser
          .mustExist('.form-group').
          execute(function(formId) {
            var values = AutoForm.getFormValues(formId).insertDoc;
            if (values.eventDate) {
              values.eventDate = String(values.eventDate);
            }
            return values;
          }, formId, function(err, res) {
            var formValues = res.value;
            _.each(expectedValues, function(fieldValuePair){

                var field = fieldValuePair[0];
                var value = fieldValuePair[1];
                var formValue = nestedStringKey(field, formValues);
                if (field == 'eventLocation') {
                  // Need to check individually so we can forgive minor floating point errors in coords
                  assert.equal(formValue.source, value.source);
                  assert.equal(formValue.zone, value.zone);
                  assert.equal(formValue.country, value.country);
                  assert.equal(formValue.geo.type, value.geo.type);
                  assert.equal(Math.round(formValue.easting * 100000),
                               Math.round(value.easting * 100000));
                  assert.equal(Math.round(formValue.northing * 100000),
                               Math.round(value.northing * 100000));
                  assert.equal(Math.round(formValue.geo.coordinates[0] * 100000),
                               Math.round(value.geo.coordinates[0] * 100000));
                  assert.equal(Math.round(formValue.geo.coordinates[1] * 100000),
                               Math.round(value.geo.coordinates[1] * 100000));
                } else if (typeof(value) == 'object' || typeof(value) == 'array') {
                  assert(_.isEqual(formValue, value));
                } else if (typeof(value) == 'number') {
                  // avoid floating point errors
                  assert(_.isEqual(Math.round(formValue * 100000), Math.round(value * 100000)));
                } else if (field === 'eventDate') {
                  assert.equal(Date(formValue), Date(value));
                } else {
                  assert.equal(formValue, value);
                }
            });
            browser.call(callback);
          });
        });

        browser.addCommand("checkTableCells", function(expectedValues, callback) {
          browser
          .waitForExist('.reactive-table', function (err, exists) {
            assert(!err);
            assert(exists);
            _.each(expectedValues, function(fieldValuePair){
              var field = fieldValuePair[0];
              var value = fieldValuePair[1];
              browser.getText('.' + field, function(err, text){
                if (field === 'eventDate') {
                  assert.equal(Date.parse(text[1]), Date.parse(value));
                } else {
                  assert.equal(text[1], String(value));
                }
              });
            });
            browser.call(callback);
          })
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
