Package.describe({
  name: 'rana:accounts',
  version: '0.0.1',
  summary: 'User accounts for the rana project'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  
  api.use('templating');
  api.use('coffeescript');
  api.use('underscore');
  api.use('mquandalle:jade@0.4.1');
  api.use('iron:router@1.0.7');
  api.use('aldeed:collection2@2.3.2');
  api.use('aldeed:autoform@4.2.2');
  api.use('accounts-password');
  api.use('useraccounts:core@1.7.0');
  
  api.addFiles('user_publication.coffee', 'server');
  
  api.addFiles('profile_schema.coffee', ['client', 'server']);
  
  api.addFiles('header_buttons.jade', 'client');
  api.addFiles('profile.jade', 'client');
  
  api.addFiles('profile.coffee', 'client');
  
  api.addFiles('accounts_config.coffee', ['client', 'server']);
  api.addFiles('profile_routes.coffee', ['client', 'server']);
  
  api.export("AccountsTemplates", ['client']);
});

