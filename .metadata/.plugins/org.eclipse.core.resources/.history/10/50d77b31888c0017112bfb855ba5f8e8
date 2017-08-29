<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Doctor_has_been_approved</fullName>
        <description>Doctor has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Doctor_approved</template>
    </alerts>
    <alerts>
        <fullName>Doctor_has_been_rejected</fullName>
        <description>Doctor has been rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Doctors_Rejected</template>
    </alerts>
    <alerts>
        <fullName>please_approve_the_addition_of_doc</fullName>
        <description>please approve the addition of doc</description>
        <protected>true</protected>
        <recipients>
            <recipient>mangesh_dev1@persistent.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>rashika@persistent.co.in</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Approval_of_Doctors</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_change_to_pending</fullName>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Status change to pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_change_to_rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status change to rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>status_change_to_approve</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>status change to approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
