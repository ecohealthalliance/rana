//Forked form https://github.com/dpankros/meteor-cfs-autoform
Package.describe({
  name: "eha:cfs-autoform",
  version: "3.0.0",
  summary: "Upload files as part of autoform submission",
  git: "https://github.com/aldeed/meteor-cfs-autoform.git"
});

Package.on_use(function(api) {
  api.use('underscore@1.0.1', 'client');
  api.use('templating@1.0.9', 'client');
  api.use('reactive-dict', ['client', 'server']);
  api.use('aldeed:autoform');
  api.use('cfs:standard-packages@0.0.2', ['client', 'server'], {weak: true});
  api.use('raix:ui-dropped-event@0.0.7', 'client');

  api.export('CfsAutoForm', 'client');

  api.add_files([
    'cfs-autoform-defs.js',
    'cfs-autoform-prefs.js',
    'cfs-autoform-deps.js',
    'cfs-autoform-hooks.js',
    'cfs-autoform-util.js',
    'cfs-autoform-events.js',
    'cfs-autoform-helpers.js',
    'cfs-autoform.js',
    'cfs-autoform.html',
    'cfs-autoform-ui.js',
    'cfs-autoform.css'
  ], 'client');
});
