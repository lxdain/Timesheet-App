global class ResetFormFilledScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        resetFormFilled();
    }

    public void resetFormFilled() {
        List<Contact> contacts = [SELECT Id, Form_Filled__c FROM Contact WHERE Employee__c = true];
        for (Contact contact : contacts) {
            contact.Form_Filled__c = false;
        }
        update contacts;
    }

    global static void scheduleJob() {
        String cronExp = '0 25 16 * * ?'; // Runs @ 16:25 every day
        String jobName = 'ResetFormFilledJob';
        System.schedule(jobName, cronExp, new ResetFormFilledScheduler());
    }
}