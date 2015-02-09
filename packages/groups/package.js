Package.describe({
  name: 'groups',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: 'Group management for meteor',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: null
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  
  api.use('templating');
  api.use('coffeescript');
  api.use('mquandalle:jade@0.4.1');
  api.use('stylus');
  api.use('email');
  api.use('iron:router@1.0.7');
  api.use('aldeed:collection2@2.3.2');
  api.use('aldeed:autoform@4.2.2');
  api.use('alanning:roles@1.2.11');
  api.use('matb33:collection-hooks@0.7.5');
  
  api.addFiles("users.coffee", ['client', 'server']);
  api.addFiles('collection.coffee', ['client', 'server']);
  
  api.addFiles('invite.jade', 'client');
  api.addFiles('group_home.jade', 'client');
  api.addFiles('new_group.jade', 'client');
  api.addFiles('join.jade', 'client');
  
  api.addFiles('invite.coffee', ['client', 'server']);
  api.addFiles('new_group.coffee', 'client');
  api.addFiles('join.coffee', 'client');
  
  api.addFiles('routes.coffee', ['client', 'server']);
  
  api.export("Groups", ['client', 'server']);
});

