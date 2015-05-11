getCollections = => @collections

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  subscriptions: () ->
    Meteor.subscribe "groupByPath", "rana"

Router.onRun () ->
  if Session.equals('AnalyticsJS_loaded', true)
    analytics.page @path
  @next()

Router.route "/",
  name: 'home'

Router.route('newReport',
  path: '/study/:studyId/report'
  template: 'reportForm'
  where: 'client',
  data: ->
    type: 'insert'
    study: getCollections().Studies.findOne @params.studyId
    urlQuery: @params.query
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

    obfuscated = false
    if report
      if report.dataUsePermissions is 'Share obfuscated' and report.createdBy.userId != Meteor.userId()
        obfuscated = true
      study = null
      if report.studyId
        study = getCollections().Studies.findOne report.studyId
      type = if Meteor.userId() and Meteor.userId() == report.createdBy.userId
          'update'
        else
          'readonly'

    type: type
    report: report
    study: study
    urlQuery: @params.query
    obfuscated: obfuscated
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("reportAndStudy", @params.reportId)
      Meteor.subscribe("obfuscatedReportAndStudy", @params.reportId)
    ]

)

Router.route('newStudy',
  path: '/study'
  template: 'studyForm'
  where: 'client'
  data: ->
    type: 'insert'
  onAfterAction: ->
    Meteor.subscribe("genera")
)

Router.route('editStudy',
  path: '/study/:studyId'
  template: 'study'
  where: 'client'

  data: ->
    study = getCollections().Studies.findOne @params.studyId

    obfuscated = false
    if study
      if study.dataUsePermissions is 'Share obfuscated' and study.createdBy.userId != Meteor.userId()
        obfuscated = true
      type = if Meteor.userId() and Meteor.userId() == study.createdBy.userId
          'update'
        else
          'readonly'

    type: type
    study: getCollections().Studies.findOne(@params.studyId)
    reports: getCollections().Reports.find({studyId: @params.studyId})
    urlQuery: @params.query
    obfuscated: obfuscated
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("studies", @params.studyId)
      Meteor.subscribe("obfuscatedStudies", @params.studyId)
    ]
)

Router.route('/studies',
  where: 'client'
)

Router.route('/table',
  where: 'client'
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

Router.route('help',
  where: 'client'
)

Router.plugin 'ensureSignedIn', {only: ['newReport', 'editReport', 'newStudy']}
