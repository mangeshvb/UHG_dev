<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>mail_to_patient_for_receipt</fullName>
        <description>mail to patient for receipt</description>
        <protected>false</protected>
        <recipients>
            <recipient>mangesh_dev11@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nishith12@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nishith1@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/patient_prescription_and_next_visit</template>
    </alerts>
    <alerts>
        <fullName>patients_presrciption_and_next_visit_date</fullName>
        <description>patients presrciption and next visit date</description>
        <protected>false</protected>
        <recipients>
            <recipient>mangesh_dev11@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nishith12@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>nishith1@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/patient_prescription_and_next_visit</template>
    </alerts>
    <fieldUpdates>
        <fullName>status_update</fullName>
        <field>Appointment_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>send patient%27s receipt</fullName>
        <actions>
            <name>mail_to_patient_for_receipt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL(Fees__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>status change to pending</fullName>
        <actions>
            <name>status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
