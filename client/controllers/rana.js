/*
 * Original: https://github.com/aldeed/meteor-autoform/blob/d35d1d8ddb6b6a5e212875fc3b9ba4c464401aa3/templates/bootstrap3/bootstrap3.js
 * Template helpers for "rana" template
 */

Template['afFormGroup_rana'].helpers({
  skipLabel: function bsFormGroupSkipLabel() {
    var self = this;

    var type = AutoForm.getInputType(self.afFieldInputAtts);
    return (self.skipLabel || type === "boolean-checkbox");
  },
  bsFieldLabelAtts: function bsFieldLabelAtts() {
    var atts = _.clone(this.afFieldLabelAtts);
    // Add bootstrap class
    atts = AutoForm.Utility.addClass(atts, "control-label");
    return atts;
  }
});

_.each([
    "afSelect_rana",
    "afTextarea_rana",
    "afInputText_rana",
    "afInputDate_rana",
    "afInputNumber_rana",
    "afInputEmail_rana",
    "afInputTel_rana"
  ], function (tmplName) {
  console.log('templateName', tmplName);
  // console.log('Template[tmplName]', Template[tmplName]);
  Template[tmplName].helpers({
    atts: function addFormControlAtts() {
      var atts = _.clone(this.atts);
      console.log('adding atts', atts)
      // Add bootstrap class
      atts = AutoForm.Utility.addClass(atts, "form-control");
      return atts;
    }
  });
});

_.each([
    "afCheckboxGroup_rana",
    "afRadioGroup_rana"
  ], function (tmplName) {
  Template[tmplName].helpers({
    atts: function selectedAttsAdjust() {
      var atts = _.clone(this.atts);
      if (this.selected) {
        atts.checked = "";
      }
      // remove data-schema-key attribute because we put it
      // on the entire group
      delete atts["data-schema-key"];
      return atts;
    },
    dsk: function dsk() {
      return {
        "data-schema-key": this.atts["data-schema-key"]
      }
    }
  });
});

var selectHelpers = {
  optionAtts: function afSelectOptionAtts() {
    var item = this;
    var atts = {
      value: item.value
    };
    if (item.selected) {
      atts.selected = "";
    }
    return atts;
  }
};
Template["afSelect_rana"].helpers(selectHelpers);

Template["afBooleanRadioGroup_rana"].helpers({
  falseAtts: function falseAtts() {
    var atts = _.omit(this.atts, 'trueLabel', 'falseLabel', 'data-schema-key');
    if (this.value === false) {
      atts.checked = "";
    }
    return atts;
  },
  trueAtts: function trueAtts() {
    var atts = _.omit(this.atts, 'trueLabel', 'falseLabel', 'data-schema-key');
    if (this.value === true) {
      atts.checked = "";
    }
    return atts;
  },
  dsk: function () {
    return {'data-schema-key': this.atts['data-schema-key']};
  }
});