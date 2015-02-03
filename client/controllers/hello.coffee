if (Meteor.isClient)
  Session.setDefault "counter", 5

  Template.hello.helpers
    counter: () ->
      return Session.get "counter"

  Template.hello.events
    'click button': () ->
      Session.set "counter", Session.get("counter") + 1

if (Meteor.isServer)
  Meteor.startup () ->
