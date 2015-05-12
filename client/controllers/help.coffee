# videos = new

videos = [
  {
    title: "Accessing the System"
    videoID: "2ceRzc0ZeXE"
    script: "Anonymous visitors to the site can view tables and maps of reports that have been shared with the public, and can download bulk exports of shared reports.

To add your own content to the site by creating new studies and reports, you'll need an account.

To sign up for an account, click the Sign In button in the upper-right-hand corner of the screen, and then click the Register link below the form.

You must enter your email address, a password, and your name. Optionally, you may also enter your organizational contact details, which will then become the default contact information for any new studies and reports you create."
  }
  {
    title: "Adding a Study"
    videoID: "QGqY3ZLs9cA"
    script: "All reports in the Ranavirus Reporting System are associated with a study, so to create a reports you must first create the study they belong to. Start by clicking the Add Study link at the top of the page.

At a minimum, you need to give the study a name, enter the details for the contact person on the study (these will default to your account's contact information if you have provided it), and specify if and how you want to share and publish the records in this study.

You may also specify any of a number of additional fields that will become default values for new reports added to this study. Some fields have helpful explanations which can be shown by placing your cursor over the question mark icon.

You may also choose to import report records from a CSV file that will be associated with your new study. After uploading a CSV file, you will be shown a preview of the values for the fields that will be imported, and a list of fields that will not be imported because they were not known to the system. See the (CSV Import Instructions)[/importInstructions] to learn how to structure your import file."
  }
  {
    title: "Adding a Report"
    videoID: "rMOMeRrp8tE"
    script: "To add a report, first click on the View Studies link in the menu at the top of the screen, and find the study you want to work with and click the Add Report button. On the report form, you will see that the default values for reports in that study have already been filled in. Fill in the fields that apply to your report, and click the Submit button to save your report to the system."
  }
  {
    title: "Viewing Reports"
    videoID: "Rc_yDdby8rc"
    script: "There are two ways to view collections of reports that have been submitted to the system: the table view, and the map views. Both views allow you to see all of your own reports, as well as all other reports that have been shared publicly."
  }  
  {
    title: "Report Table"
    videoID: "Dgn4gysDO80"
    script: "To see report data in a tabular view, click View Reports in the top menu. You'll see a number of important fields for each report in the database to which you have access. You can page through the results, and filter them based on values for selected fields."
  }  
  {
    title: "Exporting a Report"
    videoID: "5kAYSaPXJek"
    script: "From the report table, View Reports, you can also export the report data in CSV format. The export will respect any filters that you have enabled for the table. Click the Export button, and you browser will download a CSV file containing all report records that you have permission to view which match you filter settings."
  }  
  {
    title: "Report Map"
    videoID: "NSbuPXwiCS4"
    script: "The map view places markers on a world map for each report that has geographic coordinates associated with it. Clicking on a marker opens a window with more information and a liink to view or edit the report.

Reports can be filtered as in the report table, and they can be sorted into color-coded groups according to their values for various fields."
  }  
]

Template.help.helpers
  'videos' : () ->
    _.map(videos, (v, i) ->
      _.extend(v, {'index': i+1})
      )

Template.help.helpers
  addActive: (i) ->
    if i is 1
      'active'

Template.help.events
  'click .topic': (e) ->
    $link = $(e.target)
    $topic = $('.topic-'+$link.attr('id'))
    $('.topics a').removeClass('active')
    $link.addClass('active')
    $('.topic-content').removeClass('active')
    $topic.addClass('active')
    if ($(window).width() <= 768)
      $('html, body').animate({
          scrollTop: $topic.offset().top
      }, 1000);
