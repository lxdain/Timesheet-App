public class TimesheetController {
    public Timesheet__c timesheet { get; set; }
    public Contact contact { get; set; }
    public List<ProjectWrapper> projects { get; set; }

    public TimesheetController() {
        String md5Token = ApexPages.currentPage().getParameters().get('md5Token');
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Form_Filled__c FROM Contact WHERE MD5_Token__c = :md5Token LIMIT 1];
        
        timesheet = new Timesheet__c();
        
        if (!contacts.isEmpty()) {
            contact = contacts[0];
            timesheet.Employee__c = contact.Id;
        } else {
            contact = new Contact();
        }

        projects = new List<ProjectWrapper>();
        for (Project__c project : [SELECT Id, Name FROM Project__c]) {
            projects.add(new ProjectWrapper(project));
        }
    }

    public class ProjectWrapper {
        public Project__c project { get; set; }
        public Boolean selected { get; set; }

        public ProjectWrapper(Project__c project) {
            this.project = project;
            this.selected = false;
        }
    }

    public PageReference submitForm() {
        String selectedActivities = '';
        for (ProjectWrapper wrapper : projects) {
            if (wrapper.selected) {
                selectedActivities += wrapper.project.Name + '; ';
            }
        }
        timesheet.Activities__c = selectedActivities;
        insert timesheet;
    
        for (ProjectWrapper wrapper : projects) {
            if (wrapper.selected) {
                Timesheet_Project__c junction = new Timesheet_Project__c();
                junction.Timesheet__c = timesheet.Id;
                junction.Project__c = wrapper.project.Id;
                insert junction;
            }
        }
    
        contact.Form_Filled__c = true;
        update contact;
        return Page.ReportFormCompleted;
    }

    public PageReference checkFormFilled() {
        if (contact != null && contact.Form_Filled__c) {
            PageReference pageRef = new PageReference('/ReportFormCompleted');
            pageRef.setRedirect(true);
            return pageRef;
        }
        return null;
    }
}