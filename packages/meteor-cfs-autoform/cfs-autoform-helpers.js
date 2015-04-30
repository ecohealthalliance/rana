/**
 * Template Helper functions
 * @type {Object}
 */
helpers = {

  /**
   * isUploading
   * @return {Boolean} true if the file currently uploading
   * @this helpers
   */
  isUploading: function() {

    CfsAutoForm.deps.add('percentComplete');
    var files = this.atts[CfsAutoForm.defs.uploaded_file_data] || [];
    if (files.length === 0) {
      return false;
    }

    var result = _(files).reduce(
        function(last, file) {
          CfsAutoForm.deps.add('percentComplete', file._id);
          return last || (file.uploadProgress() < 100);
        }, false);

    return result;
  },

  /**
   * percentComplete
   * @return {Number} The percentage of the files that has been uploaded. For a
   * list of files, percent complete returns the average of all the files
   * Returns 0 is the file is not uploading or if there has been an error.
   * @this helpers
   */
  percentComplete: function() {
    var files = this.atts[CfsAutoForm.defs.uploaded_file_data] || [];
    if (files.length === 0) {
      CfsAutoForm.deps.add('percentComplete');
      return 0;
    }

    var percent = _(files).reduce(
        function(memo, file) {
          CfsAutoForm.deps.add('percentComplete', file._id);
          return memo + file.uploadProgress();
        }, 0) / files.length;

    return percent;
  },


  /**
   * collection
   * @return {String} the name of the files collection
   * @this helpers
   */
  collection: function() {
    return this.atts.collection;
  },


  /**
   * The filename
   * @return {String} the filename
   * @this helpers
   */
  filename: function() {
    return this.name;
  },


  /**
   * the attributes to be set on the embedded file tag
   * @return {String} the attributes
   * @this template
   */
  fileUploadAtts: function() {
    var atts;
    atts = _.clone(this.atts);
    delete atts.collection;
    return atts;
  },

  /**
   * Has anything changed on this element?
   * @return {Boolean} true if no modifications have been made
   * to this file (not removed or uploaded)
   * @this template
   */
  isUnchanged: function() {
    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);
    return (this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.unchanged);
  },

  /**
   * Has anything been updated/changed on this element?
   * @return {Boolean} true if a new file has been uploaded
   * @this template
   */
  isUpdated: function() {
    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);
    return (this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.updated);
  },

  /**
   * Has this element been removed?
   * @return {Boolean} true the file has been removed
   * @this template
   */
  isRemoved: function() {
    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);
    return (this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.removed);
  },

  /**
   * Does this file have a thumbnail?
   * @return {Boolean}
   * @this template
   */
  hasThumbnail: function() {
    CfsAutoForm.deps.add('status');
    if (this instanceof FS.File){
      return (CfsAutoForm.getTemplate(this) === 'fileThumbImg')
    }
    var ids = [];
    var files = [];
    ids = this.atts[CfsAutoForm.defs.id_attr];

    if (this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.updated ||
      this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.removed) {
      return false;
    }

    var result = _(files).reduce(
      function(last,file){
        CfsAutoForm.deps.add('status', file._id);
        return last || (file.uploadProgress() < 100);
      }, false);


    return helpers.isImage.apply(this);
  },

  /**
   * Is this file an image?
   * @return {Boolean} true if the file is an image
   * @this template
   */
  isImage: function() {
    CfsAutoForm.deps.add('status');
    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);

    //initial checks
    if (!helpers.isFile.apply(this)) return false;
    if (this.atts[CfsAutoForm.defs.id_attr] === CfsAutoForm.defs.dummy_id_val)
      return false;

    var fileId = this.atts[CfsAutoForm.defs.id_attr];
    var collection = this.atts['collection'];
    var fileObj = CfsAutoForm.getFileWithCollectionAndId(collection, fileId);
    return (CfsAutoForm.getTemplate(fileObj) === 'fileThumbImg');
  },

  /**
   * isFile
   * @return {Boolean} true if there is an id and the file
   * hasn't been flagged for removal
   * @this template
   */
  isFile: function() {
    CfsAutoForm.deps.add('status');
    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);

    return (this.atts[CfsAutoForm.defs.id_attr].length > 0) &&
           (this.atts[CfsAutoForm.defs.status_attr] !== CfsAutoForm.defs.status.removed);
  },

  /**
   * isEmpty
   * @return {Boolean} true when there is no file uploaded (i.e. blank insert
   * form or file has been removed)
   * @this template
   */
  isEmpty: function() {
    CfsAutoForm.deps.add('status');
    if (this instanceof FS.File) return false;

    CfsAutoForm.deps.add('status', this.atts[CfsAutoForm.defs.id_attr]);
    var files = CfsAutoForm.getFile.apply(this);

    return (this.atts[CfsAutoForm.defs.status_attr] === CfsAutoForm.defs.status.removed ||
            this.atts[CfsAutoForm.defs.id_attr] == CfsAutoForm.defs.dummy_id_val ||
            this.atts[CfsAutoForm.defs.id_attr].length == 0) ||
            files.length > 0;
  },

  /*
   * thumbSrc
   * @return {String} the source for this file's thumbnail
   * @this template
   */
  thumbSrc: function() {
    CfsAutoForm.deps.add('status');
    if (this instanceof FS.File){
      CfsAutoForm.deps.add('status', this._id);
      return CfsAutoForm.getThumbnailSrc(this) || 'unknown';
    }
    var file = CfsAutoForm.getFile.apply(this);
    CfsAutoForm.deps.add('status', file._id);
    return CfsAutoForm.getThumbnailSrc(file) || 'unknown';
  },


  /**
   * Returns an appropriate icon for a particular filename.  This can be used,
   * for example, if a thumbnail is not available
   * @return {String} the fontawesome icon name
   * @this template
   */
  icon: function() {
    var id;
    var collection;
    var fileObj;

    fileObj = CfsAutoForm.getFile.apply(this);

    if (!id) return '';

    var icon;
    var file;
    if (fileObj) {
      file = fileObj.original.name.toLowerCase();
      icon = 'file-o';
      if (file.indexOf('youtube.com') > -1) {
        icon = 'youtube';
      } else if (file.indexOf('vimeo.com') > -1) {
        icon = 'vimeo-square';
      } else if (file.indexOf('.pdf') > -1) {
        icon = 'file-pdf-o';
      } else if (file.indexOf('.doc') > -1 || file.indexOf('.docx') > -1) {
        icon = 'file-word-o';
      } else if (file.indexOf('.ppt') > -1) {
        icon = 'file-powerpoint-o';
      } else if (file.indexOf('.avi') > -1 ||
                 file.indexOf('.mov') > -1 ||
                 file.indexOf('.mp4') > -1) {
        icon = 'file-movie-o';
      } else if (file.indexOf('.png') > -1 ||
                 file.indexOf('.jpg') > -1 ||
                 file.indexOf('.jpeg') > -1 ||
                 file.indexOf('.gif') > -1 ||
                 file.indexOf('.bmp') > -1) {
        icon = 'file-image-o';
      } else if (file.indexOf('http://') > -1 ||
                 file.indexOf('https://') > -1) {
        icon = 'link';
      }
      return icon;
    }
  },

  file: function() {
    var files = [];
    //existing files
    var collection = this.atts[CfsAutoForm.defs.collection_attr];
    var ids = this.atts[CfsAutoForm.defs.id_attr] || [];
    if (typeof ids === 'string'){
      ids = ids.split(',');
    }
    ids=_(ids).without(CfsAutoForm.defs.dummy_id_val);
    if (ids.length > 0) {
      return CfsAutoForm.getFileWithCollectionAndId(collection, ids[0]);
    }
    return undefined;
  },

  files: function() {
    console.log("files");
    var files = [];
    //existing files
    var collection = this.atts[CfsAutoForm.defs.collection_attr];
    var ids = this.atts[CfsAutoForm.defs.id_attr] || [];
    if (typeof ids === 'string'){
      ids = ids.split(',');
    }
    ids=_(ids).without(CfsAutoForm.defs.dummy_id_val);
    ids.forEach(function(id){
      CfsAutoForm.deps.add('status', id);
      files.push(CfsAutoForm.getFileWithCollectionAndId(collection, id));
    });

    //uploading files
    ids = this.atts[CfsAutoForm.defs.uploaded_file_data] || [];
    ids.forEach(function(id){
      CfsAutoForm.deps.add('status', id);
      files.push(CfsAutoForm.getFileWithCollectionAndId(collection, id));
    });
    return files;
  }
};
