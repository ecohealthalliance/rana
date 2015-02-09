Router.configure
  layoutTemplate: "layout"

Router.route "/", () ->
  Router.go "/group/rana"
