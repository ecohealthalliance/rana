var getFieldTypes = function(schema) {
  var types = {};
  _.each(schema, function (value, key) {
    // studyId is designated as a select via options passed in via
    // a helper, so it's not in the schema and can't be detected here.
    if (key == 'studyId') {
      types[key] = 'select';
    }  else if (value.optional) {
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
    } else if (value.type.name) {
      types[key] = value.type.name;
    } else {
      types[key] = value.autoform.type;
    }

  });
  return types
}

module.exports = {

  setFormFields: function(schema, formData, browser) {
    var schemaTypes = getFieldTypes(schema);
    _.each(formData, function (value, key) {
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

}
