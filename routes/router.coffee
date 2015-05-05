getCollections = => @collections

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"

Router.route('/', ()-> @redirect('/group/rana'))

Router.route('newReport',
  path: '/study/:studyId/report'
  template: 'reportForm'
  where: 'client',
  data: ->
    type: 'insert'
    study: getCollections().Studies.findOne @params.studyId
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("studies", @params.studyId)
    ]
)

Router.route('editReport',
  path: '/report/:reportId'
  template: 'reportForm'
  where: 'client'
  data: ->
    report = getCollections().Reports.findOne @params.reportId
    if report
      study = getCollections().Studies.findOne report.studyId
      type = if Meteor.userId() and Meteor.userId() == report.createdBy.userId
          'update'
        else
          'readonly'

    type: type
    report: report
    study: study
    urlQuery: @params.query
  onAfterAction: ->
    Meteor.subscribe("genera")
    Meteor.subscribe("reviews", @params.reportId)
  waitOn: ->
    [
      Meteor.subscribe("reportAndStudy", @params.reportId)
    ]
)

Router.route('newStudy',
  path: '/study'
  template: 'studyForm'
  where: 'client'
  onAfterAction: ->
    Meteor.subscribe("genera")
)

Router.route('editStudy',
  path: '/study/:studyId'
  template: 'study'
  where: 'client'
  data: ->
    study: getCollections().Studies.findOne(@params.studyId)
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("studies", @params.studyId),
      Meteor.subscribe("groupByPath", "rana")
    ]
)

Router.route('/studies',
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("groupByPath", "rana")
    ]
)

Router.route('/table',
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("groupByPath", "rana")
    ]
)

Router.route('/map',
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("reportLocations")
    ]
)

Router.route('/info',
  where: 'client'
)

Router.route('/importInstructions',
  where: 'client'
)

Router.plugin 'ensureSignedIn', {only: ['newReport', 'editReport', 'newStudy']}
