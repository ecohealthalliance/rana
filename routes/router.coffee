getCollections = => @collections

Router.configure
  layoutTemplate: "layout"

Router.route('/form',
  where: 'client'
)

Router.route('/map',
  where: 'client'
  data: ->
    getCollections().Reports.find({
        location: { $ne : null }
      })
      .map((report)-> {
        location: report.location.split(',').map(parseFloat)
        popupHTML: '<a href="">#{report.name}</a>'
      })
  #waitOn: ->
    #[
      #Meteor.subscribe("reports")
    #]
)

Router.route('/info',
  where: 'client'
)
