getCollections = => @collections

Template.filteredView.created = ->
  @query = new ReactiveVar()
  @groupBy = new ReactiveVar()

Template.filteredView.groupBy = ->
  Template.instance().groupBy

Template.filteredView.query = ->
  Template.instance().query

Template.filteredView.filteredReports = ->
  reports: getCollections().Reports.find(Template.instance().query.get())
  groupBy: Template.instance().groupBy.get()


