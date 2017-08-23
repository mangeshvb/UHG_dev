<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Alert_Comments_at_Display</fullName>
        <field>Alert_Comments_at_Display__c</field>
        <formula>Alert__r.Alert_Comments__c</formula>
        <name>Set Alert Comments at Display</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Alert_Title_at_Display</fullName>
        <field>Alert_Title_at_Display__c</field>
        <formula>Alert__r.Alert_Title__c</formula>
        <name>Set Alert Title at Display</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Interaction Alert Created</fullName>
        <actions>
            <name>Set_Alert_Comments_at_Display</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Alert_Title_at_Display</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Interaction__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
