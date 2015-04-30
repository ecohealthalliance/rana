
var beforeInsertHook = function(doc) {
  return commonUpdateHook.apply(this, [doc, '']);
};

var beforeUpdateHook = function(modifier) {
  return commonUpdateHook.apply(this, [modifier, '$set.']);
};
var commonUpdateHook = function(doc, prefix) {
  var self = this;
  if (!AutoForm.validateForm(this.formId)) {
    return false;
  }
  var totalFiles = 0;
  var arrayFields = {};

  function getFileCountForElementAndKey(elem, key) {
    // Get list of files that were attached for this key
    //var delayed = elem.data(CfsAutoForm.defs.delayed_upload_files_data) || [];
    //var uploaded = elem.data(CfsAutoForm.defs.uploaded_file_data) || [];
    //
    ////we have to include the old files too
    //var existing = elem.data(CfsAutoForm.defs.completed_files_data) || [];
    //
    ////total = existing + delayed + uploaded
    //var theTotalFiles = existing.length;
    //theTotalFiles += delayed.length;
    //theTotalFiles += uploaded.length;

    var ids = (elem.attr(CfsAutoForm.defs.id_attr) || '').split(',');
    ids = _(ids).without('', CfsAutoForm.defs.dummy_id_val);
    var theTotalFiles = ids.length;
    console.log("Counted " + theTotalFiles + " files.");

    return theTotalFiles;
  }

  this.template.$(CfsAutoForm.defs.hidden_css).each(function() {
    var elem = $(this);
    // Get schema key that this input is for
    var key = elem.attr('data-schema-key');

    // no matter what, we want to delete the dummyId value
    //delete doc[key];
    CfsAutoForm.util.deepDelete(doc, prefix + key);
    //autoform inserts a key of the form 'key.0' for an array, which we don't want

    //fixup to correct strange behavior by autoform when dealing with arrays
    var prop = key + '.0';
    var elements = (prefix + prop).split('.');
    var parentPath = _(elements).initial(2).join('.');
    if (CfsAutoForm.util.hasProperty(doc, parentPath)) {
      CfsAutoForm.util.deepDo(doc, parentPath, function(obj, attr) {
        obj = obj[attr];
        if (obj.hasOwnProperty(prop)) {
          delete obj[prop];
        }
      });
    }

    var ids = (elem.attr(CfsAutoForm.defs.id_attr) || '').split(',');
    ids = _(ids).without(CfsAutoForm.defs.dummy_id_val);

    totalFiles += getFileCountForElementAndKey(elem, key);
  });

  // If no files were attached, updated or deleted anywhere on the form,
  // we're done and We pass back the doc synchronously.  The easy case.
  if (totalFiles === 0) {
    return doc;
  }

  // Create the callback that will be called either
  // upon file insert error or upon each file being uploaded.
  var doneFiles = 0;
  var failedFiles = 0;

  function onCompleteCb(error, fileObj, key) {
    // Increment the done files count
    doneFiles++;

    var schema = AutoForm.getSchemaForField(key);
    var isArray = schema.type() instanceof Array;

    // Increment the failed files count if it failed
    if (error) {
      failedFiles++;
    }
    // If it didn't fail, set the new ID as the property value in the doc,
    // or push it into the array of IDs if it's a multiple files field.
    else {
      if (! fileObj) { //deleted
        if (prefix) {
          CfsAutoForm.util.deepSet(doc, '$unset.' + key, '', true);
        }
        //CfsAutoForm.util.deepDelete(doc, prefix + key);
      } else if (isArray) {
        if (CfsAutoForm.util.deepFind(doc, prefix + key)[key] == undefined) {
          //create the array if it doesn't exist
          CfsAutoForm.util.deepSet(doc, prefix + key, [], true);
        }
        CfsAutoForm.util.deepFind(doc, prefix + key)[key].push(fileObj._id);
      } else {
        CfsAutoForm.util.deepSet(doc, prefix + key, fileObj._id);
      }
    }

    // If this is the last file to be processed, pass execution back to autoform
    if (doneFiles === totalFiles) {
      // If any files failed
      if (failedFiles > 0) {
        // delete all that succeeded
        if (CfsAutoForm.prefs.get('deleteOnFailure')) {
          CfsAutoForm.deleteUploadedFiles(template);
        }
        // pass back to autoform code, telling it we failed
        self.result(false);
      } else {  // Otherwise if all files succeeded
        // pass updated doc back to autoform code, telling it we succeeded
        self.result(doc);
      }
    }
  }

  // Loop through all hidden file fields, inserting
  // and uploading all files that have been attached to them.
  this.template.$(CfsAutoForm.defs.hidden_css).each(function() {
    var elem = $(this);

    function uploadFiles(fileList) {
      console.log('begin upload');
      _.each(fileList, function(file) {
        fileObj = CfsAutoForm.uploadFile(
            file,
            fsCollection,
            {
              onComplete: function() {
                if (!CfsAutoForm.prefs.get('uploadOnSelect')) {
                  elem.attr(CfsAutoForm.defs.id_attr, file._id);
                }
                // track successful uploads so we can delete them if any
                // of the other files fail to upload
                var uploadedFiles = elem.
                    data(CfsAutoForm.defs.completed_files_data) || [];
                uploadedFiles.push(fileObj);
                elem.data(CfsAutoForm.defs.completed_files_data, uploadedFiles);
                onCompleteCb(null, fileObj, key);
              },
              onError: onCompleteCb
            });
      });
    }
    function processUploadedFiles(file) {
      if (! file) return;
      var files = elem.data(CfsAutoForm.defs.completed_files_data) || [];
      files.push(file);
      elem.data(CfsAutoForm.defs.completed_files_data, files);

      onCompleteCb(null, file, key);
    }

    // Get schema key that this input is for
    var key = elem.attr('data-schema-key');
    var ids = (elem.attr(CfsAutoForm.defs.id_attr) || '').split(',');
    ids = _(ids).without(CfsAutoForm.defs.dummy_id_val);

    // Loop through all files that were attached to this field
    ids.forEach(function(id) {
      var unchanged = (elem.attr(CfsAutoForm.defs.status_attr) ==
          CfsAutoForm.defs.status.unchanged);
      var removed = (elem.attr(CfsAutoForm.defs.status_attr) ==
          CfsAutoForm.defs.status.removed);
      var added = (elem.attr(CfsAutoForm.defs.status_attr) ==
          CfsAutoForm.defs.status.updated) ?
          (id == undefined ||
          id == CfsAutoForm.defs.dummy_id_val ||
          id.length === 0) : false;
      var updated = (elem.attr(CfsAutoForm.defs.status_attr) ==
          CfsAutoForm.defs.status.updated) ? (! added) : false;
      var value = elem.val();

      if (updated || added) {
        var fsCollectionName = elem.attr(CfsAutoForm.defs.collection_attr);
        var fsCollection = CfsAutoForm.getCfsCollection(fsCollectionName);
        if (CfsAutoForm.prefs.get('uploadOnSelect')) {
          //already uploaded
          processUploadedFiles(
              CfsAutoForm.getFileWithCollectionAndId(fsCollection, id));
        } else {
          //we need to upload
          uploadFiles(elem.data(CfsAutoForm.defs.delayed_upload_files_data));
        }
      } else if (removed) {
        var deleteFiles = elem.data(CfsAutoForm.defs.delete_files_data) || [];
        deleteFiles.push(id);
        elem.data(CfsAutoForm.defs.delete_files_data, deleteFiles);
        onCompleteCb(undefined, undefined, key);
        //NOTE: deletes are performed, if at all, in the after hook
      } else if (unchanged) {
        onCompleteCb(undefined,
            CfsAutoForm.getFileWithCollectionAndId(fsCollection, id));
      }
    }, this);
  });
  //returns to AutoForm asynchronously.
}

var afterHook = function(error, result) {
  var elems = this.template.$(CfsAutoForm.defs.hidden_css);
  if (error) {
    if (CfsAutoForm.prefs.get('deleteOnFailure')) {
      CfsAutoForm.deleteUploadedFiles(this.template);
    }
    if (FS.debug || AutoForm._debug)
      console.log('There was an error inserting so all uploaded files were removed.', error);
  } else { //success
    //delete the files flagged for such
    if (CfsAutoForm.prefs.get('deleteOnRemove')) {
      CfsAutoForm.deleteFiles(elems.data(CfsAutoForm.defs.delete_files_data));
    }

    // cleanup uploaded & deleted files data
    elems.removeData(CfsAutoForm.defs.filenames_data);
    elems.removeData(CfsAutoForm.defs.files_multi_data);
    elems.removeData(CfsAutoForm.defs.completed_files_data);
    elems.removeData(CfsAutoForm.defs.uploaded_file_data);
    elems.removeData(CfsAutoForm.defs.delete_files_data);

    //remove/cleanup attributes
    elems.attr(CfsAutoForm.defs.id_attr, '');
    elems.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.unchanged);
  }
}

var onErrorHook = function onErrorHook(formType, error){
  console.log("Error detected on form type " + formType + ":" + error);
};

// The layout of the Hooks object MUST match what autoform expects
// in the addHooks call.
hooks = {
  before: {
    insert: beforeInsertHook,
    update: beforeUpdateHook
  },


  after: {
    insert: afterHook,
    update: afterHook
  },

  onError: onErrorHook,

  onSuccess: function() {
    //TODO: delete files that were successfully removed
  }
};