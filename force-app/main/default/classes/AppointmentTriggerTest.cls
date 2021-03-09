@isTest
public class AppointmentTriggerTest {
	@isTest
    public static void singleAppointmentTest() {
        Patient__c patient = new Patient__c(Name = 'Test Patient',Age__c = 20);
        insert patient;
        Doctor__c doctor = new Doctor__c(Name = 'Test Doctor');
        insert doctor;
        Appointment__c appoint  = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient.Id);
        Test.startTest();
        insert appoint;
        Test.stopTest();
        Doctor__c doc = [SELECT Critical_Patient__c from Doctor__c][0];
        System.assertEquals(patient.Id, doc.Critical_Patient__c );
    }
    @isTest 
    public static void bulkAppointmentTest() {
        List<Patient__c> patients = new List<Patient__c>();
        for(Integer i=0;i<5;i++) {
            patients.add(new Patient__c(Name = 'Test Patient ' + i,Age__c = 50+i));
        }
        insert patients;
        List<Doctor__c> doctors = new List<Doctor__c>();
        for(Integer i=0;i<2;i++) {
        	doctors.add(new Doctor__c(Name = 'Test Doctor '+ i));
        }
        insert doctors;
        List<Appointment__c> appoints = new List<Appointment__c>();
        for(Integer i=0;i<5;i++) {
            if(i<3) {
                appoints.add(new Appointment__c(Doctor__c = doctors[0].Id,Patient__c = patients[i].Id));
            }
            else{
                appoints.add(new Appointment__c(Doctor__c = doctors[1].Id,Patient__c = patients[i].Id));
            }
        }
        Test.startTest();
        insert appoints;
        Test.stopTest();
        List<Doctor__c> doc = [SELECT Critical_Patient__c,Critical_Patient__r.Age__c from Doctor__c];
        System.assertEquals(52,doc[0].Critical_Patient__r.Age__c );
        System.assertEquals(54,doc[1].Critical_Patient__r.Age__c );
    }
    @isTest
    public static void singleUpdateTest(){
        Patient__c patient1 = new Patient__c(Name = 'Test Patient',Age__c = 20);
        Patient__c patient2 = new Patient__c(Name = 'Test Patient 2',Age__c = 19);
        insert patient1;
        insert patient2;
        Doctor__c doctor = new Doctor__c(Name = 'Test Doctor');
        insert doctor;
        Appointment__c appoint1  = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient1.Id);
        Appointment__c appoint2 = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient2.Id);
        insert appoint1;
        insert appoint2;
        Test.startTest();
        patient2.Age__c = 25;
        update patient2;
        Test.stopTest();
        Doctor__c doc = [SELECT Critical_Patient__c from Doctor__c][0];
        System.assertEquals(appoint2.Patient__c,doc.Critical_Patient__c );
    }
    @isTest
    public static void bulkAppointmentUpdateTest() {
        List<Patient__c> patients = new List<Patient__c>();
        for(Integer i=0;i<5;i++) {
            patients.add(new Patient__c(Name = 'Test Patient ' + i,Age__c = 50+i));
        }
        insert patients;
        List<Doctor__c> doctors = new List<Doctor__c>();
        for(Integer i=0;i<2;i++) {
        	doctors.add(new Doctor__c(Name = 'Test Doctor '+ i,Critical_Patient__c = patients[0].Id ));
        }
        insert doctors;
        List<Appointment__c> appoints = new List<Appointment__c>();
        for(Integer i=0;i<5;i++) {
            if(i<3) {
                appoints.add(new Appointment__c(Doctor__c = doctors[0].Id,Patient__c = patients[i].Id));
            }
            else{
                appoints.add(new Appointment__c(Doctor__c = doctors[1].Id,Patient__c = patients[i].Id));
            }
        }
        insert appoints;
        Test.startTest();
        patients[0].Age__c = 60;
        update patients[0];
        Test.stopTest();
        List<Doctor__c> doc = [SELECT Critical_Patient__c,Critical_Patient__r.Age__c from Doctor__c];
        System.assertEquals(60,doc[0].Critical_Patient__r.Age__c );
        System.assertEquals(54,doc[1].Critical_Patient__r.Age__c );
    }
    @isTest
    public static void checkDeletePatient(){
        Patient__c patient1 = new Patient__c(Name = 'Test Patient',Age__c = 20);
        Patient__c patient2 = new Patient__c(Name = 'Test Patient 2',Age__c = 23);
        insert patient1;
        insert patient2;
        Doctor__c doctor = new Doctor__c(Name = 'Test Doctor');
        insert doctor;
        Appointment__c appoint1  = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient1.Id);
        Appointment__c appoint2 = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient2.Id);
        insert appoint1;
        insert appoint2;
        Test.startTest();
        delete appoint2;
        Test.stopTest();
        Doctor__c doc= [ SELECT Critical_Patient__c,Critical_Patient__r.Age__c from Doctor__c][0];
        System.assertEquals(appoint1.Patient__c, doc.Critical_Patient__c);
    }
    @isTest
    public static void checkDeletePatientError(){
        try{
            Patient__c patient1 = new Patient__c(Name = 'Test Patient',Age__c = 20);
        	insert patient1;
        Doctor__c doctor = new Doctor__c(Name = 'Test Doctor');
        insert doctor;
        Appointment__c appoint1  = new Appointment__c(Doctor__c = doctor.Id,Patient__c = patient1.Id);
        insert appoint1;
        Test.startTest();
		delete appoint1;
        Test.stopTest();
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('Cannot Delete a single Critical Patient'));
        }
    }
}