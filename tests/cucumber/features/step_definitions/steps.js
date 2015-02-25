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
    
    this.Then(/^I should see the title of "([^"]*)"$/, function (expectedTitle, callback) {
      helper.world.browser.
        title(function (err, res) {
          assert.equal(res.value, expectedTitle);
          callback();
        });
    });

    this.fillInForm = function (customValues, callback) {
      helper.world.browser
      .waitForExist('.form-group')
      .execute(function(){
        var schema = collections.Reports.simpleSchema()._schema;
        var types = {};
        _.each(schema, function (value, key) {
          if (value.optional) {
              types[key] = 'optional';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.afFieldInput.options &&
              value.autoform.afFieldInput.noselect) {
            types[key] = 'radio';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.options &&
              value.autoform.afFieldInput.noselect) {
            types[key] = 'radio';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.afFieldInput.options) {
            types[key] = 'select';
          } else if (value.autoform &&
              value.autoform.afFieldInput &&
              value.autoform.options) {
            types[key] = 'select';
          } else if (value.autoform &&
                     value.autoform.rows) {
            types[key] = 'textarea';
          } else if (value.autoform &&
                     value.autoform.afFieldValueContains) {
            types[key] = 'optional';
          } else {
            types[key] = value.type.name;
          }
        });
        
        return {
          formData: AutoForm.Fixtures.getData(collections.Reports.simpleSchema()),
          schemaTypes: types
        };
      }, function(err, res){
        if(err) {
          return callback.fail(err);
        } else {
          var schemaTypes = res.value.schemaTypes;
          var generatedFormData = res.value.formData;
          generatedFormData['email'] = 'a@b.com';
          generatedFormData['institutionAddress']['postalCode'] = '12345';
          generatedFormData['images'] = [];
          generatedFormData['pathologyReports'] = [];
          generatedFormData['publicationInfo']['pdf'] = null;
          generatedFormData['eventLocation'] = null;
          if (generatedFormData.hasOwnProperty('eventDate')) {
            generatedFormData['eventDate'] = new Date(
              JSON.parse(generatedFormData['eventDate']))
              .toISOString().slice(0,10);
          }
          _.extend(generatedFormData, customValues);

          var browser = helper.world.browser;
          _.each(generatedFormData, function (value, key) {
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
            } else if (schemaTypes[key] = 'optional') {
              // do nothing
            } else {
              var error = 'unknown type in schema: ' + schemaTypes[key];
              callback.fail(error);
            }
          });
          callback();
        }});
    };
    
    this.When(/^I fill out the form with the (name|email|eventDate) "([^"]*)"$/,
    function(prop, value, callback){
      var customValues = {};
      customValues[prop] = value;
      helper.fillInForm(customValues, callback);
    });
    
    this.When("I fill out the form", function(callback){
      helper.fillInForm({}, callback);
    });

    this.When("I create a report without consenting to publish it",
    function(callback){
      var customValues = {};
      customValues['consent'] = false;
      helper.fillInForm(customValues, callback);
    });

    this.When(/^I click submit$/, function (callback) {
      helper.world.browser
        .click('[type=submit]')
        .call(callback);
    });

    this.When('I click the "$buttonName" button',
    function (buttonName, callback) {
      var buttonNameToSelector = {
        "Columns" : ".reactive-table-columns-dropdown button"
      };
      var selector = buttonName;
      if(buttonName in buttonNameToSelector) {
        selector = buttonNameToSelector[buttonName];
      }
      helper.world.browser
        .click(selector)
        .call(callback);
    });

    this.Then(/^the webpage should( not)? display a validation error$/,
    function(shouldNot, callback){
      helper.world.browser
      .isExisting('.has-error', function(err, exists){
        if(err) return callback.fail(err);
        if(!shouldNot && !exists) return callback.fail("Missing validation error");
        if(shouldNot && exists) return callback.fail("Validation error");
        callback();
      });
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
        assert(!err);
        if(shouldNot) {
          assert(!ret.value, 'Report found');
        } else {
          assert.equal(ret.value.length, 1, 'Incorrect number of reports');
        }
      })).call(callback);
    });
    
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
    
    this.Then(/my reports without consent should(not)? be avaible/,
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
    
    this.When(/^I click on a report location marker$/,
    function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-marker-icon')
        .click('.leaflet-marker-icon')
        .call(callback);
    });
    
    this.Then(/^I should see a popup with information from the report$/,
    function (callback) {
      helper.world.browser
        .waitForExist('.leaflet-popup-content')
        .getText('.leaflet-popup-content', function(err, value){
          assert(!err);
          var props = [
            'date',
            'type of population',
            'vertebrate classes',
            'species affected name',
            'number of individuals involved'
          ];
          for(var i=0;i<props.length;i++) {
            var prop = props[i];
            assert(RegExp(prop, "i").test(value), "Missing Property: " + prop);
          }
        }).call(callback);
    });

    this.Given(/^there is a report( with a geopoint)? in the database$/,
    function(withGeo, callback) {
      helper.resetTestDB([{
        consent: true,
        dataUsePermissions: "Share full record",
        email: "test@test.com",
        eventLocation: "25.046919772516173,121.55189514218364",
        name: "Mock data",
        phone: "12345"
      }], function(){
        helper.world.browser
        .executeAsync(function(done){
          Tracker.autorun(function(){
            var report = collections.Reports.findOne({
              eventLocation: {$exists: true}
            });
            if(report) done(report);
          });
          window.setTimeout(done, 2000);
        }, _.once(function(err, ret){
          assert(!err);
          assert(ret.value, "No reports with a geopoint in the database");
          callback();
        }));
      });
    });
    
    this.Given(/^there are no reports in the database$/,
    function (callback) {
      helper.resetTestDB([], callback);
    });
    
    this.Given("I register an account", function(callback){
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
      .setValue('#at-field-email', 'test@user.com')
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
  
    this.When("I log in", function(callback){
      helper.world.browser
      .url(helper.world.cucumber.mirror.rootUrl + "sign-in")
      .waitForExist(".form-control", function(err, exists){
        assert(!err);
        assert(exists);
      })
      .setValue('#at-field-email', 'test@user.com')
      .setValue('#at-field-password', 'testuser')
      .submitForm('#at-field-email', function(err){
        assert(!err);
      })
      .waitForExist(".form-control", 500, true, function(err, dne){
        assert(!err);
        assert(dne);
      })
      .call(callback);
    });
  
    this.Given(/I am( not)? authenticated/,
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
    
    this.When("I log out",
    function (callback) {
      helper.world.browser
        .click('.at-nav-button')
        .call(callback);
    });
    
  };

})();