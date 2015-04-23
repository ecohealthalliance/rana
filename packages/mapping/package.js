// package metadata file for Meteor.js
'use strict';

Package.describe({
  name: 'rana:mapping',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'mapping functions for leaflet and csv imports',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: null
});

Package.onUse(function(api) {

  api.versionsFrom('METEOR@1.0');

  api.use(
    [
      'coffeescript',
      'proj4:proj4',
    ]
  );

  api.addFiles('lib/mapping.coffee');

  api.export('Mapping');

});
