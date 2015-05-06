// This is a fork of https://github.com/yogiben/meteor-autoform-file
Package.describe({
  name: "eha:autoform-file",
  summary: "File upload for AutoForm",
  description: "File upload for AutoForm",
  version: "0.2.5"
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');

  api.use(
    [
    'coffeescript',
    'underscore',
    'templating',
    'less',
    'aldeed:autoform@4.2.2 || 5.1.2'
    ],
    'client');

  api.addFiles('lib/client/autoform-file.html', 'client');
  api.addFiles('lib/client/autoform-file.less', 'client');
  api.addFiles('lib/client/autoform-file.coffee', 'client');
});
