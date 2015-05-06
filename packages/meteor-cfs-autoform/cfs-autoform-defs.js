

defs = {
  /*
   * Attributes
   */
  //the mongo id of the uploaded file
  id_attr: 'data-cfsaf-id',

  //the status of the current field.
  //see status enum below for value descriptions
  status_attr: 'data-cfsaf-status',

  //the name of the cfs collection
  collection_attr: 'data-cfs-collection',

  //list of file names.  Displayed on the field and used in the before hook
  filenames_data: 'cfsaf-files',

  //list of files that need uploading for "on submit" uploading
  delayed_upload_files_data: 'cfsaf-files-to-upload',

  //Array of FS.File objects describing asynchronously uploaded files
  uploaded_file_data: 'cfsaf-uploaded-file',

  //Array of FS.File objects that have been uploaded, counted, and complete.
  completed_files_data: 'cfsaf-completed-files',

  //list of files to delete
  delete_files_data: 'cfsaf_delete-files',

  //deprecated.  Merged into filenames_data
  files_multi_data: 'cfsaf_files_multi',

  /*
   * Values
   */
  //placeholder id for new, unuploaded fields.  Redundant with status of o and
  //probably not needed anymore.  It is a good choice to eliminate later
  dummy_id_val: 'dummyId',

  /*
   * status - values for cfsaf-status to indicate whether a field has been
   * changed and the interpretation changes slightly based on whether the id
   * attribute has ben set, to wit:
   *
   *               id undefined      id defined
   * removed       undefined case    existing file to be removed
   * updated       file to be added  existing file updated
   * unchanged     blank             nothing to update
   */
  status: {
    removed: 'r',   //r-removed
    updated: 'u',   //u-updated
    unchanged: 'o', //o-original
    error: 'e'      //e-error
  },

  /*
   * CSS class names
   */
  hidden_class: 'cfsaf-hidden',
  hidden_css: '.cfsaf-hidden',

  field_class: 'cfsaf-field',
  field_css: '.cfsaf-field'
};
