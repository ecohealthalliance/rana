/**
 * Top-level CfsAutoForm Object
 * @external CfsFile
 * @external FS.Collection
 */

/**
 * Top-level CfsAutoForm Object
 * @type {{}|CfsAutoForm}
 */
CfsAutoForm = CfsAutoForm || {};


/**
 * The utility methods
 * @type {util}
 */
CfsAutoForm.util = util;


/**
 * Predefined hooks
 * @type {hooks}
 */
CfsAutoForm.hooks = hooks;


/**
 * Preference defaults
 * @type {prefs}
 */
CfsAutoForm.prefs = prefs;


/**
 * Helper functions
 * @type {helpers}
 */
CfsAutoForm.helpers = helpers;


/**
 * Event handlers
 * @type {events}
 */
CfsAutoForm.events = events;


/**
 * Dependency-related functions and methods
 * @type {deps}
 */
CfsAutoForm.deps = deps;


/**
 * Constant definitions: generally for attribute names, CSS classes, etc..
 */
CfsAutoForm.defs = defs;


/**
 * Deletes any uploaded files in a specified template
 * @param {template} template - A meteor template containing an autoform
 */
CfsAutoForm.deleteUploadedFiles = function(template) {
  template.$(CfsAutoForm.defs.hidden_css).each(function() {
    var uploadedFiles = $(this).data(CfsAutoForm.defs.completed_files_data) || [];
    _.each(uploadedFiles, function(f) {
      CfsAutoForm.deleteFiles(f);
    });
  });
};


/**
 * Deletes the file or files specified by f
 * @param {(CfsFile|CfsFile[])} f - a single file or an array of files
 * @return {*} the result of the delete operation
 */
CfsAutoForm.deleteFiles = function(f) {
  if (_.isUndefined(f)) return;

  if (f instanceof Array) {
    //if f is a files list, recurse and delete the files
    _.each(f, CfsAutoForm.deleteFiles);
  } else if (f instanceof FileList) {
    //if f is a files list, recurse and delete the files
    _.each(f, CfsAutoForm.deleteFiles);
  } else {
    //otherwise just delete the one file
    return f.remove();
  }
};


/**
 * Returns the source url (e.g. the src attribute for an img tag)
 * for specified file object
 * @param {String} fileObj - the target file
 * @return {String} the url for the thumbnail
 */
CfsAutoForm.getThumbnailSrc = function(fileObj) {
  if (!fileObj) return undefined;

  var thumbStore = CfsAutoForm.getThumbnailStore(fileObj.getCollection());
  return fileObj.url({store: thumbStore.name}) || undefined;
};


/**
 * returns a template name for the file
 * @deprecated Unused
 * @param {(CfsFile|String)} file - A file name or a CfsFile object
 * @return {String} the template name
 */
CfsAutoForm.getTemplate = function(file) {
  var template;
  if (typeof(file) === 'string') {
    file = file.toLowerCase();
    template = 'fileThumbIcon';
    if (file.indexOf('.jpg') > -1 ||
        file.indexOf('.jpeg') > -1 ||
        file.indexOf('.png') > -1 ||
        file.indexOf('.gif') > -1) {
      template = 'fileThumbImg';
    }
  } else if (file instanceof FS.File) {
    switch (file.type().toLowerCase()) {
      case 'image/jpg':
      case 'image/jpeg':
      case 'image/png':
      case 'image/gif':
        template = 'fileThumbImg';
        break;
      default:
        template = 'fileThumbIcon';
    }
  }
  return template;
};


CfsAutoForm.singleHandler = function(event, template) {
  var files = [];
  var fileNames =  [];

  if (event.type === 'drop') {
    var fileList = event.originalEvent.dataTransfer ?
        event.originalEvent.dataTransfer.files : event.currentTarget.files;
    //only grab the FIRST file, if there are multiple
    files.push(fileList[0]);
    fileNames.push(fileList[0].name);
  }else if (event.type === 'change') {
    FS.Utility.eachFile(event, function(f) {
      files.push(f);
      fileNames.push(f.name);
    });
  }else {
    console.log("ERROR: Caught unhandled event of type " + event.type);
  }

  //UI Update
  template.$(CfsAutoForm.defs.field_css).val(fileNames.join(', '));

  if (files.length === 0) {
    return;
  }

  if (prefs.get('uploadOnSelect')) {
    var fsCollectionName = this.atts[CfsAutoForm.defs.collection_attr];
    var fsCollection = CfsAutoForm.getCfsCollection(fsCollectionName);

    var elem = template.$(CfsAutoForm.defs.hidden_css);
    elem.data(CfsAutoForm.defs.filenames_data, fileNames);
    elem.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.updated);

    var f = files[0];
    var fileObj = CfsAutoForm.uploadFile(f, fsCollection, {
      onComplete: function(f) {
        //elem.data(CfsAutoForm.defs.uploaded_file_data, f);
        elem.attr(CfsAutoForm.defs.id_attr, f._id);
        CfsAutoForm.deps.changed('status');
        CfsAutoForm.deps.changed('status', f._id);
      },
      onError: function(a, b, c) {
        console.log('Error uploading.');
        //template.data.atts[CfsAutoForm.defs.uploaded_file_data] = 'Error';
        template.$(CfsAutoForm.defs.hidden_css).
          attr[CfsAutoForm.defs.status] = CfsAutoForm.defs.status.error;
      }
    }, this);
    //set so that UI helpers have data during upload
    var ufd = this.atts[CfsAutoForm.defs.uploaded_file_data] || [];
    ufd.push(fileObj)
    this.atts[CfsAutoForm.defs.uploaded_file_data] = ufd;

  } else { //Upload On Submit
    var elem = template.$(CfsAutoForm.defs.hidden_css);
    elem.data(CfsAutoForm.defs.filenames_data, fileNames);
    elem.data(CfsAutoForm.defs.delayed_upload_files_data, files);
    elem.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.updated);
    CfsAutoForm.deps.changed('status', elem.attr(CfsAutoForm.defs.id_attr));
    //NOTE: id and uploaded-file get set when the file is actually uploaded
    //delayed_upload_files_data is a list of the files that need uploading
  }
  CfsAutoForm.deps.changed('status');
};

CfsAutoForm.multipleHandler = function(event, template) {
  var newFiles = [];
  var newNames = [];

  //move the fileList into fileArray
  if (event.type==='drop'){
    var fileList = event.originalEvent.dataTransfer ?
      event.originalEvent.dataTransfer.files : event.currentTarget.files;

    for(var i=0;i<fileList.length;i++){
      newFiles.push(fileList[i]);
      newNames.push(fileList[i].name);
    }
  }else if (event.type==='change'){
    FS.Utility.eachFile(event, function (f) {
      newFiles.push(f);
      newNames.push(f.name);
    });
  }else {
    console.log("ERROR: Caught unhandled event of type " + event.type);
  }

  //UI Update
  var existingNames = template.$(CfsAutoForm.defs.field_css).val() || '';
  existingNames = existingNames.split(',');
  var filenames = _(existingNames).without('').concat(newNames);
  template.$(CfsAutoForm.defs.field_css).val(filenames.join(', '));

  if (newFiles.length === 0) {
    return;
  }

  if (prefs.get('uploadOnSelect')) {
    var fsCollectionName = this.atts[CfsAutoForm.defs.collection_attr];
    var fsCollection = CfsAutoForm.getCfsCollection(fsCollectionName);

    var elem = template.$(CfsAutoForm.defs.hidden_css);
    elem.data(CfsAutoForm.defs.filenames_data, filenames);
    elem.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.updated);

    newFiles.forEach(function(f, index, a) {
      var fileObj = CfsAutoForm.uploadFile(f, fsCollection, {
        onComplete: function(f) {
          var ufd = elem.data(CfsAutoForm.defs.uploaded_file_data) || [];
          ufd.push(f);
          elem.data(CfsAutoForm.defs.uploaded_file_data, ufd);
          var ids = elem.attr(CfsAutoForm.defs.id_attr);
          if (!ids) {
            ids = f._id;
          } else {
            ids = ids + ',' + f._id;
          }
          elem.attr(CfsAutoForm.defs.id_attr, ids);
          CfsAutoForm.deps.changed('status');
          CfsAutoForm.deps.changed('status', f._id);
        },
        onError: function(a, b, c) {
          console.log('Error uploading.');
          //template.data.atts[CfsAutoForm.defs.uploaded_file_data] = 'Error';
          template.$(CfsAutoForm.defs.hidden_css).
            attr[CfsAutoForm.defs.status] = CfsAutoForm.defs.status.error;
        }
      }, this);
      //set so that UI helpers have data during upload
      var ufd = this.atts[CfsAutoForm.defs.uploaded_file_data] || [];
      ufd.push(fileObj)
      this.atts[CfsAutoForm.defs.uploaded_file_data] = ufd;
    }, this);
  } else { //Upload On Submit
    var elem = template.$(CfsAutoForm.defs.hidden_css);
    elem.data(CfsAutoForm.defs.filenames_data, newNames);
    var filesToUpload = (elem.data(CfsAutoForm.defs.delayed_upload_files_data) || [])
      .concat(newFiles);
    elem.data(CfsAutoForm.defs.delayed_upload_files_data, filesToUpload);
    elem.attr(CfsAutoForm.defs.status_attr, CfsAutoForm.defs.status.updated);
    //NOTE: id and uploaded-file get set when the file is actually uploaded
    //delayed_upload_files_data is a list of the newFiles that need uploading
    CfsAutoForm.deps.changed('status', elem.attr(CfsAutoForm.defs.id_attr));
  }
  CfsAutoForm.deps.changed('status');
};


/**
 * Returns a CfsFile when provided the collection name and the id of the file
 * @param {String} collection - the name of the collection
 * @param {String} id - the id attribute of the file
 * @return {CfsFile} The CfsFile object
 * @this CfsAutoForm
 */
CfsAutoForm.getFileWithCollectionAndId = function(collection, id) {
  if (! id) return undefined;
  var cObj = this.getCfsCollection(collection);
  return cObj ? cObj.findOne(id) : undefined;
};


/**
 * Returns the FS.Collection for a collection name or object.  Will
 * simply return the same object
 * if a FS.Collection is passed in.
 * @param {(String|FS.Collection)} collection - the name of the collection
 * or a collection object
 * @return {FS.Collection} A collection object
 */
CfsAutoForm.getCfsCollection = function(collection) {
  if (! collection) return undefined;

  if (typeof(collection) === 'string') {
    return FS._collections[collection];
  } else if (collection instanceof FS.Collection) {
    return collection;
  }
  return undefined;
};


/**
 * Returns a store for the collection that has a particular name
 * @param {(String|FS.Collection)} collection - A collection name or object
 * @param {String} storeName - the name of the store
 * @return {*} The store object
 * @this CfsAutoForm
 */
CfsAutoForm.getStoreForCollectionWithName = function(collection, storeName) {
  if ( !storeName || storeName === '' ) return undefined;

  var cObj = this.getCfsCollection(collection);
  return cObj ? cObj.storesLookup[storeName] : undefined;
};


/**
 * returns the store named in CfsAutoForm.prefs.thumbnailStore or, if undefined,
 * the last store defined for the collection.
 * @param {(FS.Collection|String)} collection - A collection name or
 * FS.Collection object
 * @return {*} the store object
 * @this CfsAutoForm
 */
CfsAutoForm.getThumbnailStore = function(collection) {
  var store;

  //use a predefined store name
  if (this.prefs.get('thumbnailStore')) {
    store = this.getStoreForCollectionWithName(collection,
        this.prefs.get('thumbnailStore'));
  } else { //otherwise, use last store
    var cObj = this.getCfsCollection(collection);
    if (cObj) {
      store = cObj.options.stores[cObj.options.stores.length - 1];
    }
  }
  return store;
};


/**
 * UploadFile
 * @param {String} file - the file to upload
 * @param {String} collection - the collection object to
 * insert the uploaded file
 * @param {Object} hooks - (optional) an object containing
 * functions to execute upon various events.  e.g.
 * {
 *    onComplete: function(fileObj) {
 *      console.log('File Uploaded!';
 *    },
 *    onError: function(error, fileObj, key) {
 *      console.log('File failed to upload');
 *    },
 *    onInterval: function(file, interval) {
 *      console.log('File is ' + file.uploadProgress() + ' complete.');
 *    }
 * }
 *
 */
CfsAutoForm.uploadFile = function(file, collection, hooks) {
  // Create the FS.File instance
  var fileObj = new FS.File(file);

  hooks = hooks || {};

  // Listen for the 'uploaded' event on this file, so that we
  // can call our callback. We want to wait until uploaded rather
  // than just inserted. XXX Maybe should wait for stored?
  if (hooks.onComplete) {
    fileObj.once('uploaded',
        function() {
          console.log('Triggering onComplete hook.');
          hooks.onComplete(fileObj);
        }
    );
  }

  // Insert the FS.File instance into the FS.Collection
  collection.insert(fileObj, function(error, fileObj) {
    // call callback if insert/upload failed
    if (error && hooks.onError) {
      console.log('Triggering onError hook.');
      hooks.onError(error, fileObj, key);
      //cb(error, fileObj, key);
    }
  });

  //progress indicator
  var intervalId = setInterval(function() {
    CfsAutoForm.deps.create('percentComplete');
    CfsAutoForm.deps.changed('percentComplete');
    CfsAutoForm.deps.create('percentComplete', fileObj._id);
    CfsAutoForm.deps.changed('percentComplete', fileObj._id);

    if (fileObj.uploadProgress() >= 100) {
      clearInterval(intervalId);
    }
    if (hooks.onInterval) {
      hooks.onInterval(fileObj, intervalId);
    }
  }, CfsAutoForm.prefs.get('uploadRefreshInterval'));

  return fileObj;
};


/**
 * getFile
 * @returns {FS.File}
 */
CfsAutoForm.getFile = function getFile() {
  if (this instanceof FS.File){
    return this;
  }

  var collection = this.atts.collection;
  var file = this._id;
  var fileObj = CfsAutoForm.getFileWithCollectionAndId(collection, file);

  if (!fileObj) {

    file = this.atts[CfsAutoForm.defs.id_attr];
    if (file instanceof Array){
      file = file[0];
    }
    fileObj = CfsAutoForm.getFileWithCollectionAndId(collection, file);

    if (!fileObj) { //fallback to the uploaded, but not saved, image.
      fileObj = (this.atts[CfsAutoForm.defs.uploaded_file_data] || [])[0];
    }
  }
  return fileObj;
};
