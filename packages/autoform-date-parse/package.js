// package metadata file for Meteor.js
'use strict';

Package.describe({
  name: 'autoform-date-parse',
  version: '0.0.1',
  summary: 'Autoform input for parsing freeform date strings'
});

Package.onUse(function(api) {

  api.versionsFrom('METEOR@1.0');

  api.use(
    [
      'coffeescript',
      'templating',
      'stylus',
      'mquandalle:jade',
      'aldeed:autoform'
    ], 'client'
  );

  api.addFiles('lib/client/autoform-date-parse.jade', 'client');
  api.addFiles('lib/client/autoform-date-parse.coffee', 'client');
  api.addFiles('lib/client/autoform-date-parse.styl', 'client');

});
