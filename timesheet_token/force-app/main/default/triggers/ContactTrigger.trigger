trigger ContactTrigger on Contact (before insert) {
    for (Contact contact : Trigger.new) {
        if (contact.Employee__c) {
            String data = contact.Email + DateTime.now().getTime();
            Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(data));
            contact.MD5_Token__c = EncodingUtil.convertToHex(hash);
        }
    }
}