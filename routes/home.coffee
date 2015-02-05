Router.configure
  layoutTemplate: "layout"

Router.route "/", () ->
  Router.go "/org/rana"
