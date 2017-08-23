<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Third_Party_Name</fullName>
        <field>FullName__c</field>
        <formula>IF(OR(ISNULL(First_Name__c), ISBLANK(First_Name__c)), Name, First_Name__c &amp; &apos; &apos; + Name)</formula>
        <name>Update Third Party Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACET Update Third Party Fields Workflow Rule</fullName>
        <actions>
            <name>Update_Third_Party_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED( First_Name__c) || ISCHANGED(  Name )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
