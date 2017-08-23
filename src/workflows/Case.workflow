<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ECM_Check_Priority_Routing</fullName>
        <description>This sets Priority Routing to &quot;Yes&quot;</description>
        <field>Priority_Routing__c</field>
        <literalValue>Yes</literalValue>
        <name>ECM Check Priority Routing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ECM_Test_Milestone_update</fullName>
        <field>Milestone_Updated__c</field>
        <formula>text(now())</formula>
        <name>ECM Test Milestone update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ECM_Uncheck_Priority_Routing</fullName>
        <description>This sets the Priority Routing value to &quot;No&quot;</description>
        <field>Priority_Routing__c</field>
        <literalValue>No</literalValue>
        <name>ECM Uncheck Priority Routing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ECM_UpdatePriorityRoutingToYes</fullName>
        <field>Priority_Routing__c</field>
        <literalValue>Yes</literalValue>
        <name>ECM_UpdatePriorityRoutingToYes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Milestone_success</fullName>
        <field>Milestone_Updated__c</field>
        <formula>Text(now())</formula>
        <name>Milestone success</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Caller_Name</fullName>
        <field>Caller__c</field>
        <formula>Interaction__r.Contact_Name__c</formula>
        <name>Update Caller Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_DOB</fullName>
        <field>DOB__c</field>
        <formula>SUBSTITUTE(MID(SUBSTITUTE(TEXT(Contact.Birthdate), LEFT(TEXT(Contact.Birthdate),4), &apos;&apos;)
+&apos;/&apos;
+ LEFT(TEXT(Contact.Birthdate),4),2,LEN(SUBSTITUTE(TEXT(Contact.Birthdate), LEFT(TEXT(Contact.Birthdate),4), &apos;&apos;)
+&apos;/&apos;
+ LEFT(TEXT(Contact.Birthdate),4))),
&apos;-&apos;, &apos;/&apos;)</formula>
        <name>Update Case DOB</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Originator_Email</fullName>
        <field>OriginatorEmail__c</field>
        <formula>Interaction__r.Originator__r.Email</formula>
        <name>Update Case Originator Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Originator_Phone</fullName>
        <field>OriginatorPhone__c</field>
        <formula>IF(ISBLANK( Interaction__r.Third_Party__c), Interaction__r.Originator__r.Phone, Interaction__r.Third_Party__r.Phone_Number__c)</formula>
        <name>Update Case Originator Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Subject_Name</fullName>
        <field>Subject_Name__c</field>
        <formula>Contact.FirstName + &apos; &apos; + Contact.LastName</formula>
        <name>Update Case Subject Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IDs_field</fullName>
        <field>ID__c</field>
        <formula>Contact.EID__c</formula>
        <name>Update ID field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Originator_Name</fullName>
        <field>Originator_name__c</field>
        <formula>IF(ISBLANK( Interaction__r.Third_Party__c), IF(ISNULL(Interaction__r.Originator__r.FirstName), &apos;&apos;, Interaction__r.Originator__r.FirstName + &apos; &apos; + Interaction__r.Originator__r.LastName) , IF(ISNULL(Interaction__r.Third_Party__r.First_Name__c), &apos;&apos;, Interaction__r.Third_Party__r.First_Name__c+ &apos; &apos; + Interaction__r.Third_Party__r.Name) )</formula>
        <name>Update Originator Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tax_ID</fullName>
        <field>TaxID__c</field>
        <formula>Interaction__r.Originator__r.Tax_ID__c</formula>
        <name>Update Tax ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACET Update Case Fields Workflow Rule</fullName>
        <actions>
            <name>Update_Caller_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_DOB</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Originator_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Originator_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Subject_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Originator_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tax_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW()  ||  ISCHANGED( Interaction__c) ||  ISCHANGED (ContactId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
