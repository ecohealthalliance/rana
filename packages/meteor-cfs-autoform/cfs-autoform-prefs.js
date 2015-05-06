/**
 * Preferences object
 * @type {ReactiveDict}
 */

prefs = new ReactiveDict;


  //enables asynchronous uploads when a file is selected, rather than when the form is submitted
prefs.set('uploadOnSelect', true);

  //the template to use for showing upload progress
prefs.set('uploadProgressTemplate', "cfsFilesProgress");

  //whether to delete a removed file from the store(s) or just remove the reference from the doc
  //default: false - don't delete anything unless the dev explicitly requests it
prefs.set('deleteOnRemove', false);

  //whether to delete successfully uploaded files when a submit fails
  //default: true
prefs.set('deleteOnFailure', true);

  //to manually specify a thumbnail store name as a string.
  // If undefined (default), uses the LAST defined store for the FS.Collection, regardless of name
prefs.set('thumbnailStore', undefined);

//number of milliseconds between refreshes of upload indicator
prefs.set('uploadRefreshInterval', 1000);


/**
 * Messages that are displayed
 * @type {ReactiveDict}
 */
prefs.msg=new ReactiveDict;
prefs.msg.set('filePlaceholder', "Click to upload a file or drop it here");
prefs.msg.set('filesPlaceholder', "Click to upload files or drop them here");
