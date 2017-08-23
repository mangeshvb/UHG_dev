<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Submit_Date_Time_on_Fulfillment</fullName>
        <field>Submit_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Submit Date/Time on Fulfillment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fulfillment on Edit</fullName>
        <actions>
            <name>Set_Submit_Date_Time_on_Fulfillment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Create_Letter__c.Letter_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
