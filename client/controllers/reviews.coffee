getCollections = => @collections

urlParams = null

Template.reviews.helpers 
  reviews: =>
    urlParams = Iron.controller().getParams()
    if urlParams?.reportId
      getCollections().Reviews.find({
        reportId: urlParams.reportId
      })
    else
      []

Template.reviews.events
  "submit #add-review" : (e) ->
    e.preventDefault()
    comment = e.target.comment.value
    rating = e.target.rating.value
    if comment
      getCollections().Reviews.insert
        comment: e.target.comment.value
        rating: rating
        reportId: urlParams.reportId
        createdBy:
          userId: Meteor.userId()
          name: Meteor.user()?.profile?.name
      e.target.comment.value = ''