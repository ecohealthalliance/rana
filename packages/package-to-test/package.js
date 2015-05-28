Package.describe({
  name: 'package-to-test',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  
  api.use('templating');
  api.use('coffeescript');
  api.use('stylus');
  api.use('mquandalle:jade@0.4.1');
  api.use('email');
  
  // Client integration seems to freeze when these packages are included
  // api.use('iron:router@1.0.7');
  // api.use('rana:accounts@0.0.1');
  // api.use('useraccounts:core@1.7.0');
  
  api.use('aldeed:collection2@2.3.2');
  api.use('aldeed:autoform@4.2.2');
  api.use('alanning:roles@1.2.11');
  api.use('matb33:collection-hooks@0.7.11');
  api.use('perak:markdown@1.0.4');

  api.addFiles('collection.coffee', ['client', 'server']);
  
  api.addFiles('package-to-test.js');
  api.export('PackageToTest');
  api.export('Groups');
});

Package.onTest(function(api) {
  api.use('coffeescript');
  api.use('sanjo:jasmine@0.13.3');
  api.use('package-to-test');
  api.addFiles('tests/server/example-spec.js', 'server');
  api.addFiles('tests/client/example-spec.js', 'client');
  api.addFiles('tests/client/spec.coffee', 'client');
});
