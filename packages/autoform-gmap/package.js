// package metadata file for Meteor.js
'use strict';

Package.describe({
  name: 'autoform-gmap',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'Autoform google maps support',
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
      'templating',
      'stylus',
      'mquandalle:jade@0.4.1',
      'aldeed:autoform@4.2.2'
    ], 'client'
  );

  api.addFiles('lib/client/autoform-gmap.jade', 'client');
  api.addFiles('lib/client/autoform-gmap.coffee', ['client', 'server']);
  api.addFiles('lib/client/autoform-gmap.styl', 'client');

});
