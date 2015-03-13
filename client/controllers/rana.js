/*
 * Template helpers for "rana" template
 */

Template['quickForm_rana'].helpers({
  idPrefix: function () {
    return this.atts["id-prefix"];
  },
  submitButtonAtts: function bsQuickFormSubmitButtonAtts() {
    var qfAtts = this.atts;
    var atts = {};
    if (typeof qfAtts.buttonClasses === "string") {
      atts['class'] = qfAtts.buttonClasses;
    } else {
      atts['class'] = 'btn btn-primary';
    }
    return atts;
  }
});

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
    "afBooleanSelect_rana",
    "afSelectMultiple_rana",
    "afTextarea_rana",
    "afInputText_rana",
    "afInputPassword_rana",
    "afInputDateTime_rana",
    "afInputDateTimeLocal_rana",
    "afInputDate_rana",
    "afInputMonth_rana",
    "afInputTime_rana",
    "afInputWeek_rana",
    "afInputNumber_rana",
    "afInputEmail_rana",
    "afInputUrl_rana",
    "afInputSearch_rana",
    "afInputTel_rana",
    "afInputColor_rana"
  ], function (tmplName) {
  Template[tmplName].helpers({
    atts: function addFormControlAtts() {
      var atts = _.clone(this.atts);
      // Add bootstrap class
      atts = AutoForm.Utility.addClass(atts, "form-control");
      return atts;
    }
  });
});

_.each([
    "afInputButton_rana",
    "afInputSubmit_rana",
    "afInputReset_rana",
  ], function (tmplName) {
  Template[tmplName].helpers({
    atts: function addFormControlAtts() {
      var atts = _.clone(this.atts);
      // Add bootstrap class
      atts = AutoForm.Utility.addClass(atts, "btn");
      return atts;
    }
  });
});

Template["afRadio_rana"].helpers({
  atts: function selectedAttsAdjust() {
    var atts = _.clone(this.atts);
    if (this.selected) {
      atts.checked = "";
    }
    return atts;
  }
});

_.each([
    "afCheckboxGroup_rana",
    "afRadioGroup_rana",
    "afCheckboxGroupInline_rana",
    "afRadioGroupInline_rana"
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
Template["afSelectMultiple_rana"].helpers(selectHelpers);
Template["afBooleanSelect_rana"].helpers(selectHelpers);

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

Template.afArrayField_rana.helpers({
  addSharing: function(name){
    name = name.hash.name.arrayFieldName;
    if (name === "pathologyReports")
      return true
  }
})