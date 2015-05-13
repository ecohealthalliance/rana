@collections = {}

@collections.Files = new FS.Collection "files",
  stores: [ new FS.Store.GridFS "files", {} ]

@collections.CSVFiles = new FS.Collection "csvfiles",
  stores: [
    new FS.Store.GridFS "mongo_csvfiles", {}
    new FS.Store.FileSystem "fs_csvfiles", { path: "/tmp/workspace/csvfiles/" }
  ]

@collections.PDFs = new FS.Collection "pdfs",
  stores: [
    new FS.Store.GridFS("pdfs")
  ]
  filter:
    allow:
      contentTypes: ["application/pdf"]


@collections.Reports = new Mongo.Collection 'reports'
@collections.Reports.attachSchema @reportSchema


@collections.Studies = new Mongo.Collection 'studies'
@collections.Studies.attachSchema @studySchema
  
@collections.Genera = new Mongo.Collection 'genera'

@collections.Reviews = new Mongo.Collection 'reviews'

videos = [
  {
    title: "Accessing the System"
    videoID: "2ceRzc0ZeXE"
    script: "Anonymous visitors to the site can view tables and maps of reports that have been shared with the public, and can download bulk exports of shared reports.
\n\n
To add your own studies and reports to the site, you will need an account.
\n\n
To sign up for an account, click the Sign In button in the upper-right-hand corner of the screen, and then click the Register link below the form.\n\n

You must enter your email address, a password, and your name. Optionally, you may also enter your organizational contact details, which will then become the default contact information for any new studies and reports you create."
  }
  {
    title: "Adding a Study"
    videoID: "QGqY3ZLs9cA"
    script: "All reports in the Ranavirus Reporting System are associated with a study, so to create reports you must first create the study they belong to. Start by clicking the Add Study link at the top of the page.
    \n\n
    At a minimum, you need to give the study a name, enter the details for the contact person on the study (these will default to your account's contact information if you have provided it), and specify if and how you want to share and publish the records in the study.
    \n\n
    You may also specify any of a number of additional fields that will become default values for new reports added to this study. Some fields have helpful explanations which can be shown by placing your cursor over the question mark icon.
    \n\n
    You may also choose to upload report records from a CSV file that will be associated with your new study. After uploading a CSV file, you will be shown a preview of the values for the fields that will be imported, and a list of fields that will not be imported because they were not known to the system. See the [CSV Import Instructions](/importInstructions) to learn how to structure your import file."
  }
  {
    title: "Adding a Report"
    videoID: "rMOMeRrp8tE"
    script: "To add a report, first click on the View Studies link in the menu at the top of the screen, and find the study you want to work with and click the Add Report button. If you have specified any default values in the study, those fields will already be filled in on your report. Fill in the fields that apply to your report, and click the Submit button to save your report to the system."
  }
  {
    title: "Viewing Reports"
    videoID: "mnUs37Bjfro"
    script: "There are two ways to view collections of reports that have been submitted to the system: the table views, and the map view. Both views allow you to see all of your own reports, as well as all other reports that have been shared publicly."
  }  
  {
    title: "Report Table"
    videoID: "Dgn4gysDO80"
    script: """To see report data in a tabular view, click "View Reports" in the top menu. You'll see a number of important fields for each report in the database to which you have access. You can page through the results, and filter them based on values for selected fields."""
  }  
  {
    title: "Exporting a Report"
    videoID: "5kAYSaPXJek"
    script: """From the report table, "View Reports", you can also export the report data in CSV format. The export will respect any filters that you have enabled for the table. Click the Export button, and you browser will download a CSV file containing all report records that you have permission to view which match you filter settings."""
  }  
  {
    title: "Report Map"
    videoID: "NSbuPXwiCS4"
    script: "The map view places markers on a world map for each report that has geographic coordinates associated with it. Clicking on a marker opens a window with more information and a link to view or edit the report. \n\n
    Reports can be filtered as in the report table, and they can be sorted into color-coded groups according to their values for various fields."
  }  
]

@collections.Videos = new Meteor.Collection null

_.each videos, (video) ->
  @collections.Videos.insert(video)
