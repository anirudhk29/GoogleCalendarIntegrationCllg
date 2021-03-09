public class AppointmentTriggerHelper {
    public static void AssignPatientInsert(List<Appointment__c> newAppointments ) {
        List<Id> doctorIds = new List<Id>();
        List<Id> patientIds = new List<Id>();
        List<Id> appointmentsId = new List<Id>();
        for(Appointment__c app : newAppointments) {
            doctorIds.add(app.Doctor__c);
            appointmentsId.add(app.Id);
        }
        Map<Id,Id> patientsAndDocs = new Map<Id,Id>();
        Map<Id,Decimal> agesOfPatient = new Map<Id,Decimal>();
        newAppointments = [ SELECT Id,Patient__c,Patient__r.Age__c,Doctor__c,Doctor__r.Critical_Patient__c,Doctor__r.Critical_Patient__r.Age__c from Appointment__c where Id in :appointmentsId OR Doctor__c in:doctorIds ];
        for(Appointment__c app : newAppointments) {
            if(app.Doctor__r.Critical_Patient__c == null) {
                patientsAndDocs.put(app.Doctor__c,app.Patient__c);
                agesOfPatient.put(app.Patient__c,app.Patient__r.Age__c);
            }
            else if(patientsAndDocs.containsKey(app.Doctor__c)) {
                if(agesOfPatient.get(patientsAndDocs.get(app.Doctor__c)) <= app.Patient__r.Age__c) {
                    patientsAndDocs.put(app.Doctor__c,app.Patient__c);
                    agesOfPatient.put(app.Patient__c,app.Patient__r.Age__c);
                }
            }
            else{
                if(app.Doctor__r.Critical_Patient__r.Age__c <= app.Patient__r.Age__c) {
                    patientsAndDocs.put(app.Doctor__c,app.Patient__c);
                    agesOfPatient.put(app.Patient__c,app.Patient__r.Age__c);
                }
            }
        }
        List<Doctor__c> updateDoctors = new List<Doctor__c>();
        for(Doctor__c doc : [ SELECT Id,Name,Critical_Patient__c from Doctor__c where id in :doctorIds ]) {
            if(patientsAndDocs.containsKey(doc.Id)) {
                doc.Critical_Patient__c = patientsAndDocs.get(doc.Id);
				updateDoctors.add(doc);                
            }
        }
        update updateDoctors;
    }
    public static void AssignPatientInsert(List<Appointment__c> newAppointments,List<Id> falseRecords) {
        List<Id> doctorIds = new List<Id>();
        List<Id> patientIds = new List<Id>();
        List<Id> appointmentsId = new List<Id>();
        Map<Id,Id> patientsAndDocs = new Map<Id,Id>();
        Map<Id,Decimal> agesOfPatient = new Map<Id,Decimal>();
        for(Appointment__c app : newAppointments) {
            if(patientsAndDocs.containsKey(app.Doctor__c)) {
                if(agesOfPatient.get(patientsAndDocs.get(app.Doctor__c)) <= app.Patient__r.Age__c) {
                    patientsAndDocs.put(app.Doctor__c,app.Patient__c);
                    agesOfPatient.put(app.Patient__c,app.Patient__r.Age__c);
                }
            }
            else{
                    patientsAndDocs.put(app.Doctor__c,app.Patient__c);
                    agesOfPatient.put(app.Patient__c,app.Patient__r.Age__c);
            }
        }
        List<Doctor__c> updateDoctors = new List<Doctor__c>();
        for(Doctor__c doc : [ SELECT Id,Name,Critical_Patient__c from Doctor__c where id in :falseRecords ]) {
            if(patientsAndDocs.containsKey(doc.Id)) {
                doc.Critical_Patient__c = patientsAndDocs.get(doc.Id);
				updateDoctors.add(doc);                
            }
        }
        update updateDoctors;
    }
    public static void AssignPatientDelete(List<Appointment__c> toBeDeletedAppointments,Map<Id,Appointment__c> oldMapRecords) {
        List<Id> doctorIds = new List<Id>();
        //List<Id> falseRecords = new List<Id>();
        for(Appointment__c app : [ SELECT Id,Doctor__c,Doctor__r.Critical_Patient__c,Patient__c from Appointment__c where Id in :oldMapRecords.keySet() ]) {
            if(app.Doctor__r.Critical_Patient__c == app.Patient__c) {
                doctorIds.add(app.Doctor__c);  
            }
        }
        if(doctorIds.size() > 0) {
            Map<Id,List<Id>> patientsAndDocs = new Map<Id,List<Id>>();
            for(Appointment__c app : [ SELECT Id,Patient__c,Doctor__c from Appointment__c where Doctor__c in :doctorIds ]) {
                if(patientsAndDocs.containsKey(app.Doctor__c)) {
                    List<Id> tempList = patientsAndDocs.get(app.Doctor__c);
                    tempList.add(app.Patient__c);
                    patientsAndDocs.put(app.Doctor__c,tempList);
                }
                else{
                    List<Id> tempList = new List<Id>();
                    tempList.add(app.Patient__c);
                    patientsAndDocs.put(app.Doctor__c,tempList);
                }
            }
            for(Id app : oldMapRecords.keySet()) {
                Appointment__c tempAppoint = oldMapRecords.get(app);
                System.debug((patientsAndDocs.get(tempAppoint.Doctor__c)).size());
                if((patientsAndDocs.get(tempAppoint.Doctor__c)).size() == 1){
                    oldMapRecords.get(app).addError('Cannot Delete a single Critical Patient');
                }
            }
            List<Appointment__c> updateRecords = [ SELECT Id,Patient__c,Patient__r.Age__c,Doctor__c,Doctor__r.Critical_Patient__c,Doctor__r.Critical_Patient__r.Age__c from Appointment__c where (Id not in :oldMapRecords.keySet() AND Doctor__c in:doctorIds) ];
            for(Appointment__c app : updateRecords) {
                System.debug(app.Patient__r.Age__c);
            }
            AssignPatientInsert(updateRecords,doctorIds);   
        }
    }
    
}