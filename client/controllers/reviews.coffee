getCollections = => @collections

maxRating = 10

Template.reviews.helpers
  reviews: ->
    if @reportId
      getCollections().Reviews.find({
        reportId: @reportId
      })
    else
      []

  maxRating: () -> maxRating

  scaledRating: () ->
    @rating * maxRating

Template.reviews.events
  "submit #add-review" : (e, template) ->
    e.preventDefault()
    comment = e.target.comment.value
    rating = e.target.rating.value / maxRating
    if comment or rating
      getCollections().Reviews.insert
        comment: comment
        rating: rating
        reportId: template.data.reportId
        createdBy:
          userId: Meteor.userId()
          name: Meteor.user()?.profile?.name
      e.target.comment.value = ''
      e.target.rating.value = ''
