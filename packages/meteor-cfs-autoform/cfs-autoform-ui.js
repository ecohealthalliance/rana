var hookTracking = {};

if (Meteor.isClient) {
  // Adds a custom 'cfs-file' input type that AutoForm will recognize
  AutoForm.addInputType('cfs-file', {
    template: 'cfsFileField',
    valueOut: function() {
      return CfsAutoForm.defs.dummy_id_val;
    },
    contextAdjust: function(context) {
      context.atts[CfsAutoForm.defs.id_attr] = context.value;
      context.atts[CfsAutoForm.defs.status_attr] =
          CfsAutoForm.defs.status.unchanged;
      context.atts[CfsAutoForm.defs.collection_attr] = context.atts.collection;
      context.atts[CfsAutoForm.defs.uploaded_file_data, []];
      context.atts.placeholder = context.atts.placeholder ||
          CfsAutoForm.prefs.msg.get('filePlaceholder');
      context.atts['class'] = (context.atts['class'] || '') + ' ' +
          CfsAutoForm.defs.field_class;
      return context;
    }
  });


  // Adds a custom 'cfs-files' input type that AutoForm will recognize
  AutoForm.addInputType('cfs-files', {
    template: 'cfsFilesField',
    valueOut: function() {
      return [CfsAutoForm.defs.dummy_id_val];
    },
    contextAdjust: function(context) {
      var idsArray = context.value || [];
      var collection = context.atts.collection;
      context.atts[CfsAutoForm.defs.id_attr] = idsArray.join(',');
      context.atts[CfsAutoForm.defs.status_attr] =
          CfsAutoForm.defs.status.unchanged;
      context.atts[CfsAutoForm.defs.collection_attr] = collection;
      context.atts[CfsAutoForm.defs.uploaded_file_data, []];

      var files = [];
      idsArray.forEach(function(id){
        var file = CfsAutoForm.getFileWithCollectionAndId(collection, id);
        files.push(file);
      });
      context.atts[CfsAutoForm.defs.completed_files_data] = files;

      context.atts.placeholder = context.atts.placeholder ||
          CfsAutoForm.prefs.msg.get('filesPlaceholder');
      context.atts['class'] = (context.atts['class'] || '') + ' ' +
          CfsAutoForm.defs.field_class;

      return context;
    }
  });


  //attributes for the visible text field. It just shows the information
  //but is not used for submitting data to autoform.
  function textInputAtts() {
    var atts = _.clone(this.atts);
    delete atts.collection;
    // we want the schema key tied to the hidden file field only
    delete atts['data-schema-key'];
    delete atts[CfsAutoForm.defs.status_attr];
    delete atts[CfsAutoForm.defs.id_attr];
    delete atts[CfsAutoForm.defs.status_attr];
    delete atts[CfsAutoForm.defs.uploaded_file_data];

    atts['class'] = (atts['class'] || '') + ' form-control';

    return atts;
  }


  //attributes for the HIDDEN file field.  All the submitted file data comes
  //from here
  function fileInputAtts() {
    var obj = {};
    var ids = this.atts[CfsAutoForm.defs.id_attr] || [];
    if (typeof ids === 'string'){ //make sure a string is converted to an array
      ids = ids.split(',');
    }
    obj['data-schema-key'] = this.atts['data-schema-key'];
    obj[CfsAutoForm.defs.id_attr] = ids.join(',');
    obj[CfsAutoForm.defs.status_attr] = CfsAutoForm.defs.status.unchanged;
    //obj.value = this.atts[CfsAutoForm.defs.id_attr];

    ids.forEach(function(id){
        CfsAutoForm.deps.changed('status', id);
    });


    return obj;
  }

  Template['cfsFileField_bootstrap3'].helpers(
      _.extend(
          {},
          CfsAutoForm.helpers,
          {
            textInputAtts: textInputAtts,
            fileInputAtts: fileInputAtts
          }
      ));


  Template['cfsFilesField_bootstrap3'].helpers(
      _.extend(
          {},
          CfsAutoForm.helpers,
          {
            textInputAtts: textInputAtts,
            fileInputAtts: fileInputAtts
          }
      ));



  Template['cfsFileField_bootstrap3'].rendered =
      Template['cfsFilesField_bootstrap3'].rendered = function() {
        // By adding hooks dynamically on render,
        // hopefully any user hooks will have
        // been added before so we won't disrupt
        // expected behavior.
        var formId = AutoForm.getFormId();
        if (!hookTracking[formId]) {
          hookTracking[formId] = true;
          AutoForm.addHooks(formId, CfsAutoForm.hooks);
        }
      };


  Template['cfsFileField_bootstrap3'].destroyed = function() {
    var name = this.data.name;
  };


  Template.cfsFileField_bootstrap3.events(
      _.extend(
          {},
          CfsAutoForm.events,
          {
            'change .cfsaf-hidden': CfsAutoForm.singleHandler,
            'dropped .cfsaf-field': CfsAutoForm.singleHandler
          }
      ));




  //NOTE: rendered function for cfsFilesField is defined above with cfsFileField
  Template['cfsFilesField_bootstrap3'].destroyed = function() {
    var name = this.data.name;
  };


  Template.cfsFilesField_bootstrap3.events(
      _.extend(
          {},
          CfsAutoForm.events,
          {
            'change .cfsaf-hidden': CfsAutoForm.multipleHandler,
            'dropped .cfsaf-field': CfsAutoForm.multipleHandler
          }
      ));


}




