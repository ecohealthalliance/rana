Package.describe({
  name: 'eha:autoform-fixtures',
  summary: 'Get fixtures data from SimpleSchema with AutoForm',
  version: '1.1.4',
  debugOnly: true
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.2.1');
  api.use('coffeescript');
  api.use('momentjs:moment@2.8.4', 'client');
  api.use('aldeed:autoform');
  api.addFiles([
    'autoform-fixtures.coffee',
  ], 'client');
});
