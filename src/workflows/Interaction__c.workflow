<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Originator_Name</fullName>
        <field>Originator_Name__c</field>
        <formula>IF( ISBLANK(Third_Party__r.First_Name__c) , Originator__r.FirstName + &apos; &apos; +Originator__r.LastName, Third_Party__r.First_Name__c + &apos; &apos; + Third_Party__r.Name)</formula>
        <name>Update Originator Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACET Update Interaction Fields Workflow Rule</fullName>
        <actions>
            <name>Update_Originator_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(Originator__c)  || ISCHANGED (Third_Party__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
