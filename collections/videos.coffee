getCollections = => @collections

Meteor.startup () ->

  instructionsPath = Router.path 'importInstructions'

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
      script: "All reports in the Global Ranavirus Reporting System are associated with a study, so to create reports you must first create the study they belong to. Start by clicking the Add Study link at the top of the page.
      \n\n
      At a minimum, you need to give the study a name, enter the details for the contact person on the study (these will default to your account's contact information if you have provided it), and specify if and how you want to share and publish the records in the study.
      \n\n
      You may also specify any of a number of additional fields that will become default values for new reports added to this study. Some fields have helpful explanations which can be shown by placing your cursor over the question mark icon.
      \n\n
      You may also choose to upload report records from a CSV file that will be associated with your new study. After uploading a CSV file, you will be shown a preview of the values for the fields that will be imported, and a list of fields that will not be imported because they were not known to the system. See the [CSV Import Instructions](#{instructionsPath}) to learn how to structure your import file."
    }
    {
      title: "Adding a Report"
      videoID: "rMOMeRrp8tE"
      script: "To add a report, first click on the View Studies link in the menu at the top of the screen, and find the study you want to work with and click the Add Report button. If you have specified any default values in the study, those fields will already be filled in on your report. Fill in the fields that apply to your report, and click the Submit button to save your report to the system."
    }
    {
      title: "Viewing Reports"
      videoID: "E3QoMFoVXrA"
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
    {
      title: "Consent, permissions and approval"
      script: """
        Each report has three properties that affect the reports visibility to other users within the system: consent, permissions and approval. The settings for these three properties determine who can see a report on the site, and how much report detail they can view.

        ## Consent

        The report creator is asked `Do you consent to have this data published and made searchable on the Global Ranavirus Reporting System website as per the data use permissions?` If the answer is `No`, the report will only be viewable by the report creator, regardless of what permissions are selected or administrator approval. If the answer is `Yes`, the report will be made publicly viewable subject to permissions and approval.

        ## Permissions

        Reports can be shared with three levels of permissions. These permissions determine what level of visibility the information in the report has on the site, subject to administrator approval.

        `Do not share`: Anonyomous users, other logged in users, and even adminstrators, will not see the report anywhere on the site. Only the report creator will be able to view the report details and see the report in the table and map. After adding an unshared report, you can return later and choose to share the report.

        `Share obfuscated`: All users will be able to see that a report exists, but will only be able see the contact information for the user that created the report, and the country the report is located in (if specified). The report will show up in Full Reports table and on the map for the report owner, and in the Obfuscated Reports table for all other users. If other users wish to get more information about a report, they can contact the report creator.

        `Share full record`: All users will see all details of the report, and the report will appear in the Full Reports table and on the map for everyone.

        ## Approval

        There are three approval statuses for reports on the site:

        `pending`: Awaiting review by an administrator. Only visible to the report creator, and to an admin visiting the pending reports queue.

        `approved`: Visible to anyone (subject to consent and permissions settings).

        `rejected`: Visible only to the creator, or to an admin visitng the report directly.

        Every user also has one of these three statuses. Any report created by a user is automatically assigned the status of the user. For example, reports created by approved users are automatically approved and visible immediately. New users are assigned pending status by default, and must be approved by administrators. Administrators can approve or reject any user or any individual report.

        ## Visibility

        * Reports are always fully visible to their creators.
        * If a report has no consent, or it is marked as "Do not share", it's only visible to its creator and no one else.
        * If a report has consent and is not marked as "Do not share", it's visible to others according to its approval and sharing permissions settings:
            * If a report is pending or rejected, it's visible only to its creator or an admin.
            * If a report is approved, it's visible according to its sharing permissions:
                * If it set to "Share obfuscated", all users can see the report country and report creator but nothing else
                * If it set to "Share full record", all users can see all report details
      """
      }
  ]


  if Meteor.isServer
    unless getCollections().Videos.findOne()
      _.each videos, (video) ->
        getCollections().Videos.insert(video)
