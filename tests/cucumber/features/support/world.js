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
            assert.equal(err, null);
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

        browser.addCommand("getTextWhenVisible", function(selector, callback) {
          browser
          .waitForText(selector, function(err, exists){
            assert.equal(err, null);
            assert(exists, "Text does not exist");
          })
          .getText(selector, callback);
        });

        browser.addCommand("checkValue", function(query, expectedValue, callback) {
          browser
          .getValue(query, function(err, value){
            assert(!err);
            assert.equal(value, expectedValue);
          })
          .call(callback);
        });

        browser.addCommand("setFormFields", function(formData, schemaName, callback) {

          browser
          .waitForExist('.form-group', function (err, exists) {
            assert(!err);
            assert(exists);
          })
          .execute(function(schemaName) {
            return AutoForm.Fixtures.getData(collections[schemaName].simpleSchema());
          }, schemaName, function(err, res) {
            if(err) {
              return callback.fail(err);
            } else {
              var generatedValues = res.value
              if (generatedValues.hasOwnProperty('eventDate')) {
                generatedValues['eventDate'] = new Date(
                  JSON.parse(generatedValues['eventDate']))
                  .toISOString().slice(0,10);
              }

              _.extend(generatedValues, formData);

              var schemaTypes = {};
              _.each(collections[schemaName].simpleSchema()._schema, function (value, key) {
                // studyId is designated as a select via options passed in via
                // a helper, so it's not in the schema and can't be detected here.
                if (key == 'studyId') {
                  schemaTypes[key] = 'select';
                }  else if (value.optional) {
                  schemaTypes[key] = 'optional';
                } else if (value.autoform &&
                    value.autoform.afFieldInput &&
                    value.autoform.afFieldInput.options &&
                    value.autoform.afFieldInput.noselect) {
                  schemaTypes[key] = 'radio';
                } else if (value.autoform &&
                    value.autoform.afFieldInput &&
                    value.autoform.options &&
                    value.autoform.afFieldInput.noselect) {
                  schemaTypes[key] = 'radio';
                } else if (value.autoform &&
                    value.autoform.afFieldInput &&
                    value.autoform.afFieldInput.options) {
                  schemaTypes[key] = 'select';
                } else if (value.autoform &&
                    value.autoform.afFieldInput &&
                    value.autoform.options) {
                  schemaTypes[key] = 'select';
                } else if (value.autoform &&
                           value.autoform.rows) {
                  schemaTypes[key] = 'textarea';
                } else if (value.autoform &&
                           value.autoform.afFieldValueContains) {
                  schemaTypes[key] = 'optional';
                } else if (value.type.name) {
                  schemaTypes[key] = value.type.name;
                } else {
                  schemaTypes[key] = value.autoform.type;
                }
              });

              _.each(generatedValues, function (value, key) {
                if (schemaTypes[key] === 'String' ||
                    schemaTypes[key] === 'Number') {
                  if (value) {
                    browser.setValue('input[data-schema-key="' + key + '"]', value);
                  }
                } else if (schemaTypes[key] === 'textarea') {
                  browser.setValue('textarea[data-schema-key="' + key + '"]', value);
                } else if (schemaTypes[key] === 'Boolean') {
                  browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
                } else if (schemaTypes[key] === 'radio') {
                  browser.click('div[data-schema-key="' + key + '"] input[value="' + value + '"]');
                } else if (schemaTypes[key] === 'select') {
                  browser.selectByValue('select[data-schema-key="' + key + '"]', value);
                } else if (schemaTypes[key] === 'Array') {
                  _.each(value, function (element) {
                    browser.click('div[data-schema-key="' + key + '"] input[value="' + element + '"]');
                  });
                } else if (schemaTypes[key] === 'Date') {
                  browser.setValue('input[data-schema-key="' + key + '"]', '');
                } else if (schemaTypes[key] === 'Object') {
                  _.each(value, function (subValue, subKey) {
                    var schemaKey = key + '.' + subKey;
                    browser.setValue('input[data-schema-key="' + schemaKey + '"]', subValue);
                  });
                } else if (schemaTypes[key] === 'optional' || schemaTypes[key] === 'Object') {
                  // do nothing
                } else {
                  var error = 'unknown type in schema: ' + schemaTypes[key] + 'for key: ' + key;
                  throw new Error(error);
                }
              });
            }

            callback();
          });
        });

        browser.addCommand("checkFormFields", function(formId, expectedValues, callback) {
          browser
          .waitForExist('.form-group', function (err, exists) {
            assert(!err);
            assert(exists)
          }).
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
