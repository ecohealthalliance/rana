getCollections = => @collections

BASE_PATH = '/grrs'

Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  subscriptions: () ->
    Meteor.subscribe "groupByPath", "rana"

Router.onRun () ->
  if Session.equals('AnalyticsJS_loaded', true)
    analytics.page @path
  @next()

Router.route('/', ()-> @redirect BASE_PATH)

Router.route BASE_PATH + "/",
  name: 'home'

Router.route('newReport',
  path: BASE_PATH + '/study/:studyId/report'
  template: 'reportForm'
  where: 'client',
  data: ->
    study = getCollections().Studies.findOne @params.studyId
    type = if Meteor.userId() and Meteor.userId() == study.createdBy.userId
        'insert'
      else
        'disabled'

    type: type
    study: study
    urlQuery: @params.query
  onAfterAction: ->
    Meteor.subscribe("genera")
  waitOn: ->
    [
      Meteor.subscribe("studies", @params.studyId)
      Meteor.subscribe("userInfo", Meteor.userId())
    ]
)

Router.route('editReport',
  path: BASE_PATH + '/report/:reportId'
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
          'disabled'

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
      Meteor.subscribe('userInfo')
    ]

)

Router.route('newStudy',
  path: BASE_PATH + '/study'
  template: 'studyForm'
  where: 'client'
  data: ->
    type: 'insert'
  onAfterAction: ->
    Meteor.subscribe("genera")
)

Router.route('editStudy',
  path: BASE_PATH + '/study/:studyId'
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
          'disabled'

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

Router.route('importReports',
  path: BASE_PATH + '/study/:studyId/import'
  template: 'importForm'
  where: 'client',
  data: ->
    study = getCollections().Studies.findOne(@params.studyId)
    canImport = Meteor.userId() and Meteor.userId() == study.createdBy.userId

    study: study
    urlQuery: @params.query
    canImport: canImport
  waitOn: ->
    [
      Meteor.subscribe("studies", @params.studyId)
      Meteor.subscribe("userInfo", Meteor.userId())
    ]
)


Router.route('studies',
  path: BASE_PATH + '/studies'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe "groupByPath", "rana"
    ]
)

Router.route('selectImportStudy',
  path: BASE_PATH + '/selectImportStudy'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe "groupByPath", "rana"
    ]
)

Router.route('table',
  path: BASE_PATH + '/table'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe "groupByPath", "rana"
    ]
)

Router.route('pending',
  path: BASE_PATH + '/pending'
  where: 'client'
  template: 'pendingTable'
  onBeforeAction: () ->
    if not Meteor.user() or not (Roles.userIsInRole Meteor.userId(), 'admin', Groups.findOne({path:"rana"})._id)
      @redirect BASE_PATH + '/'
    else
      @next()
  waitOn: ->
    [
      Meteor.subscribe "groupByPath", "rana"
    ]
)

Router.route('map',
  path: BASE_PATH + '/map'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe("reportLocations")
    ]
)

Router.route('info',
  path: BASE_PATH + '/info'
  where: 'client'
)

Router.route('importInstructions',
  path: BASE_PATH + '/importInstructions'
  where: 'client'
)

Router.route('help',
  path: BASE_PATH + '/help'
  where: 'client'
  waitOn: ->
    [
      Meteor.subscribe "videos"
    ]
  data: ->
    videos: getCollections().Videos.find()
    video: getCollections().Videos.find().fetch()[0]
)

Router.route('helpTopic',
  path: BASE_PATH + '/help/:topic'
  where: 'client'
  template: 'help'
  waitOn: ->
    [
      Meteor.subscribe "videos"
    ]
  data: ->
    videos: getCollections().Videos.find()
    video: getCollections().Videos.findOne({title: @params.topic.replace RegExp('-', 'g'), ' ' })
)

Router.route('terms',
  path: BASE_PATH + '/terms'
  where: 'client'
)

Router.plugin 'ensureSignedIn', {only: ['newReport', 'editReport', 'newStudy']}
