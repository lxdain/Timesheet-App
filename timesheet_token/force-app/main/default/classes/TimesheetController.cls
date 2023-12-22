public class TimesheetController {
    public Timesheet__c timesheet { get; set; }
    public Contact contact { get; set; }
    public List<ProjectWrapper> projects { get; set; }

    public TimesheetController() {
        timesheet = new Timesheet__c();

        projects = new List<ProjectWrapper>();
        for (Project__c project : [SELECT Id, Name FROM Project__c]) {
            projects.add(new ProjectWrapper(project));
        }

        String md5Token = ApexPages.currentPage().getParameters().get('md5Token');
        contact = [SELECT FirstName, LastName FROM Contact WHERE MD5_Token__c = :md5Token LIMIT 1];
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
        insert timesheet;
        for (ProjectWrapper wrapper : projects) {
            if (wrapper.selected) {
                Timesheet_Project__c junction = new Timesheet_Project__c();
                junction.Timesheet__c = timesheet.Id;
                junction.Project__c = wrapper.project.Id;
                insert junction;
            }
        }
        return null;
    }
}