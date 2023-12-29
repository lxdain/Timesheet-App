# Timesheet App for Intermino

The repo you are currently looking at is a cumulation of my work during the 2 month long **[Salesforce Internship at Intermino](https://trailhead.salesforce.com/users/lxdain/trailmixes/intermino-internship).** The application is a survey automatically sent through email each day with which employees can effectively log their daily activities and tasks as well as additional information such as requesting vacancies. 

## Tech Stack

 - The survey form is built using *Visualforce Pages* and *Bootstrap*.
 - The data gets saved and processed to the Timesheet App available on the Salesforce platform using the designated TimesheetController class written in *Apex*.
 - The scheduled email job is performed through *Salesforce Flow* as it is much less limiting compared to using a separate Apex class to create a scheduled job.
 - There also exists a separate *Apex Trigger* which creates unique tokens for each employee.
 - The survey is hosted on *Salesforce Sites*.

## Data Model

The current data model has a few custom objects or custom fields which help enable the CRUD operations between the survey and the Salesforce platform.

 1. **Contact**
 2. **Timesheet__c**
 3. **Project__c**
 4. **Timesheet_Project__c**
 
The **Contact** object has an checkbox field called *Employee__c* which if checked, utilizing the aforementioned Apex Trigger generates a unique token for that particular employee on the custom *MD5_Token__c* field. This token creation also makes them eligible to receive the daily email due to a conditional set in the Salesforce Flow which regulates this behavior. There also exists a *Form_Filled__c* checkbox which automatically gets updated to true once a new Timesheet record related to each employee has been created which blocks them from accessing the survey until the next one gets sent tomorrow/

The **Timesheet__c** & **Project__c** objects are just standard functionality.
The Timesheet object is used as a template for the survey and the Project object is used to store different ongoing projects enabling the employee to select what they worked on that day.

The **Timesheet_Project__c** represents an intermediary or junction object which helps us loop over the existing projects so that we may display them as checkboxes on the survey.

For additional information about the data model you can refer to the [Deprecated Model](https://github.com/lxdain/Timesheet-App/blob/main/data_model_deprecated.png) & [Current Model](https://github.com/lxdain/Timesheet-App/blob/main/data_model.png) image files. The current model is very much based on the deprecated one, however, the deprecated file does of course have it's limitations. For example, I originally thought that the data collected from the timesheet survey should be stored on the User object until my mentors instructed me to use the Contact object instead due to the cost and limitations of storing such information on the User object.
