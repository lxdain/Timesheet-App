global class DailyEmailScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        sendEmails();
    }

    public void sendEmails() {
        List<Contact> contacts = [SELECT Id, FirstName, LastName, Email, MD5_Token__c, Form_Filled__c FROM Contact WHERE Form_Filled__c = false AND Employee__c = true];
        Id templateId = '00XQy000001UAvp';
        for (Contact contact : contacts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(contact.Id);
            mail.setTemplateId(templateId);
            mail.setSaveAsActivity(false);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        }
    }

    global static void scheduleJob() {
        String cronExp = '0 30 16 * * ?'; // Runs @ 16:30 every day
        String jobName = 'DailyEmailJob';
        System.schedule(jobName, cronExp, new DailyEmailScheduler());
    }
}