public class ACETGetEmployerDetailAdapterWebService extends ACETWebService{
    
    public ACETGroupDetail oACETGroupDetail;
    public Integer numberDays{get;set;}
    private string taxid;
    private string classinculde;
    private string networkId;
    public ACETGroupDetail.groupContactInfo billingInfo = new ACETGroupDetail.groupContactInfo();
    public String returningFromService;
    
    public override void getEndpoint(){
        GetEndpointDetail('GetEmployerGroupEndpoint');
    }
    
    public void getRequestBody(String groupNumber){
        system.debug('Group Number========>'+groupNumber);
        RequestBody = '{"getEmployerGroup":{"getEmployerGroupRequest":{"groupNumber":"'+groupNumber+'"}}}';       
    
    }
        
    
    private ACETGroupDetail parseSuccessAdapterResponse(String ResponseBody)
    {
       oACETGroupDetail = new ACETGroupDetail();
       oACETGroupDetail.genGroupInfo= new ACETGroupDetail.groupGeneralInfo();
       oACETGroupDetail.groupEmployeeCountInfoList = new list<ACETGroupDetail.employeeCountInfo>(); 
       oACETGroupDetail.groupAddressInfoList = new list<ACETGroupDetail.AddressInfo>();
       oACETGroupDetail.groupEligibilityInfoOpenEnrollList = new list<ACETGroupDetail.groupEligibilityInfoOpenEnroll>(); 
       
       oACETGroupDetail.GroupPlanBenefitList = new list<ACETGroupDetail.GroupPlanWrapper>(); //Benefit
        
      // added by Harish for US580447 on 4/12/2017
      // oACETGroupDetail.groupEEnrollWaiting = new ACETGroupDetail.groupEligibilityInfoEnrollWaiting();
       oACETGroupDetail.groupEligibilityInfoEnrollWaitingList = new list<ACETGroupDetail.groupEligibilityInfoEnrollWaiting>();
       oACETGroupDetail.groupEligibilityInfoTermLagList = new list<ACETGroupDetail.groupEligibilityInfoTermLag>();
       oACETGroupDetail.groupEligibilityDependentCutOff = new list<ACETGroupDetail.DependentCutOff>(); 
       oACETGroupDetail.groupEligibilityInfoOpenEnrollList = new list<ACETGroupDetail.groupEligibilityInfoOpenEnroll>(); 
       oACETGroupDetail.groupEligibilityRehireLag = new list<ACETGroupDetail.rehireLag>();
       oACETGroupDetail.groupEligibilityRetirePolicy = new list<ACETGroupDetail.retireepolicy>(); 
       oACETGroupDetail.groupEligibilityRetirePolicyTest = new list<ACETGroupDetail.retireePolicyWrapper>();
        
       //End 
       ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails;
         
       ACETGetEmployerGroupAdapterJSON2Apex ACETEGDJSON2Apex = (ACETGetEmployerGroupAdapterJSON2Apex)JSON.deserialize(ResponseBody, ACETGetEmployerGroupAdapterJSON2Apex.class);
       system.debug('ACETEGDJSON2Apex --->'+ACETEGDJSON2Apex);
       EGDetails = ACETEGDJSON2Apex.GetEmployerGroup.GetEmployerGroupResponse.EmployerGroup;
       
       generalGroupInfoMapping(EGDetails);
       groupEmployeeCountMapping(EGDetails);
       groupAddressMapping(EGDetails);
       groupContactInfoMapping(EGDetails);
       groupPlanBenefitInfoMapping(EGDetails);
       groupEligibilityInfoMapping(EGDetails); 
      
       
       return oACETGroupDetail;     
    
    }
    
    //Mapping for Group Plan Topic
    private void groupPlanBenefitInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails) {
        if(EGDetails.CustomerAccount != null) {
            for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount groupPlan: EGDetails.CustomerAccount) {
                //System.debug('Rounding 1234.............'+groupPlan.CustomerPurchase);
                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerPurchase groupPlanPurchase: groupPlan.CustomerPurchase) {
                    
                    ACETGroupDetail.GroupPlanWrapper groupPlanCustomerAcc = new ACETGroupDetail.GroupPlanWrapper();
                    groupPlanCustomerAcc.ageBandGroupPlanList = new List<ACETGroupDetail.AgeBandWrap>();
                    ACETGroupDetail.AgeBandWrap ageBandInfo;
                    
                    groupPlanCustomerAcc.bundleID = (groupPlanPurchase.benefitBundleOptionID != Null)?groupPlanPurchase.benefitBundleOptionID:'';                
                    groupPlanCustomerAcc.planID = (groupPlanPurchase.benefitBasePlan != Null)?groupPlanPurchase.benefitBasePlan:'';                
                    groupPlanCustomerAcc.Product = (groupPlanPurchase.benefitPlanDescription != Null)?groupPlanPurchase.benefitPlanDescription:'';                
                    groupPlanCustomerAcc.Accumulator = (groupPlanPurchase.timePeriodQualifier != Null)?groupPlanPurchase.timePeriodQualifier:'';                
                    networkId = '';
                    if(groupPlanPurchase.networkScheduleId != null)
                    {
                        Integer networkIdSize =  groupPlanPurchase.networkScheduleId.size();
                        for (Integer j = networkIdSize ; j > 0; j--) 
                        {
                            if(networkId == '' || networkId == null)
                            {
                                networkId = groupPlanPurchase.networkScheduleId[j-1];
                            }
                            else
                            {
                                networkId = networkId+ ', ' +groupPlanPurchase.networkScheduleId[j-1];
                            }
                        }
                    }
                    groupPlanCustomerAcc.Network =  networkId;               
                    groupPlanCustomerAcc.effecDate = (groupPlanPurchase.coverageStartDate != Null)?string.valueOf(Date.valueOf(groupPlanPurchase.coverageStartDate).format()):'';
                    groupPlanCustomerAcc.endDate = (groupPlanPurchase.coverageExpirationDate != Null)?string.valueOf(Date.valueOf(groupPlanPurchase.coverageExpirationDate).format()):'';
                    groupPlanCustomerAcc.planID = (groupPlanPurchase.benefitBasePlan != Null)?groupPlanPurchase.benefitBasePlan:'';
                    groupPlanCustomerAcc.PCPRequired =  '';
                    groupPlanCustomerAcc.PlanClass = '';
                    //System.debug('Entering.........'+groupPlanCustomerAcc);
                    
                    groupPlanCustomerAcc.PlanMettalicLevel = (groupPlanPurchase.planMetallicLevel != Null)?groupPlanPurchase.planMetallicLevel:'';
                    groupPlanCustomerAcc.Gated = (groupPlanPurchase.gatedProductIndicator != null && groupPlanPurchase.gatedProductIndicator != '')?groupPlanPurchase.gatedProductIndicator:'';                
                    
                    if(groupPlanPurchase.BillingSchedule != null)
                    {
                        for(ACETGetEmployerGroupAdapterJSON2Apex.BillingSchedule ageBand:groupPlanPurchase.BillingSchedule) {
                            //System.debug('EnteringAgeBands.........'+ageBand);
                            
                            if(ageBand.ageBandToValue != null && ageBand.ageBandFromValue != null) {
                                Integer ageBandToVal = Integer.valueOf(ageBand.ageBandToValue);
                                Integer ageBandFromVal = Integer.valueOf(ageBand.ageBandFromValue);
                                for(Integer i = ageBandFromVal; i <= ageBandToVal; i++) {
                                    ageBandInfo = new ACETGroupDetail.AgeBandWrap();
                                    ageBandInfo.AgeBand = String.valueOf(i);
                                    ageBandInfo.premium = ageBand.amount;
                                    //System.debug('EnteringAgeBands.........'+ageBandInfo);
                                    groupPlanCustomerAcc.ageBandGroupPlanList.add(ageBandInfo); 
                                    groupPlanCustomerAcc.ageBandGroupPlanList.sort();
                                }
                            }
                        }
                    }
                                        
                    oACETGroupDetail.GroupPlanBenefitList.add(groupPlanCustomerAcc);
                }  
            }
           
            System.debug('List Printing.......'+oACETGroupDetail.GroupPlanBenefitList);
        }
    }
    
    //Mapping Group Eligibility Section
   private void groupEligibilityInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
    
            if(EGDetails.GroupPopulation != null)
            {
              classinculde='';             
                        Integer classincludedSize =  EGDetails.GroupPopulation.size();
                        for (Integer j = classincludedSize; j > 0; j--) 
                        {
                            //taxId = (taxId == Null)?EGDetails.taxIdentificationNumber[j-1]:taxId + ', ' +EGDetails.taxIdentificationNumber[j-1]; 
                            if(classinculde == '' || classinculde == null)
                            {
                                classinculde = EGDetails.GroupPopulation[j-1].classesDescription;
                            }
                            else
                            {
                                classinculde = classinculde + ', ' +EGDetails.GroupPopulation[j-1].classesDescription;
                            }
                        
                        }               
                    oACETGroupDetail.genGroupInfo.classesIncluded = classinculde;
              
              
              if(EGDetails.GroupPopulation != null){
               for(ACETGetEmployerGroupAdapterJSON2Apex.GroupPopulation retirepolicydata: EGDetails.GroupPopulation)
               {
                 //     GroupEligibility OpenEnrollment 
                           ACETGroupDetail.groupEligibilityInfoOpenEnroll groupOpenEnrollment = new ACETGroupDetail.groupEligibilityInfoOpenEnroll();
                           groupOpenEnrollment.eType  = (retirepolicydata.classesDescription != null)?retirepolicydata.classesDescription:'';
                           groupOpenEnrollment.startDate =(retirepolicydata.openEnrollmentPopulationClassStartDate != null)?string.valueOf(Date.valueOf(retirepolicydata.openEnrollmentPopulationClassStartDate).format()):'';
                           groupOpenEnrollment.endDate =(retirepolicydata.openEnrollmentPopulationClassEndDate != null)?string.valueOf(Date.valueOf(retirepolicydata.openEnrollmentPopulationClassEndDate).format()):'';
                           oACETGroupDetail.groupEligibilityInfoOpenEnrollList.add(groupOpenEnrollment); 
                 if(retirepolicydata.populationGroupEnsuringRules != null){
                 for(ACETGetEmployerGroupAdapterJSON2Apex.PopulationGroupEnsuringRules groupretirepolicydata: retirepolicydata.populationGroupEnsuringRules){
                   //ACETGroupDetail.retireepolicy  groupretirepolicy = new ACETGroupDetail.retireepolicy();
                   ACETGroupDetail.retireePolicyWrapper groupretirepolicy = new ACETGroupDetail.retireePolicyWrapper();
                   groupretirepolicy.population = (retirepolicydata.classesDescription != null)?retirepolicydata.classesDescription:'';
                   groupretirepolicy.earlyretirement = (groupretirepolicydata.earlyRetirementIndicator != null)?groupretirepolicydata.earlyRetirementIndicator:'';
                   groupretirepolicy.minimumageearly = (groupretirepolicydata.earlyRetirementMinimumAge != null)?groupretirepolicydata.earlyRetirementMinimumAge:'';
                   groupretirepolicy.workingretirement =(groupretirepolicydata.workingRetirementIndicator != null)?groupretirepolicydata.workingRetirementIndicator:'';
                   groupretirepolicy.mininumageworking = (groupretirepolicydata.workingRetirementMinimumAge != null)?groupretirepolicydata.workingRetirementMinimumAge:'';
                   groupretirepolicy.fromRP = (retirepolicydata.openEnrollmentPopulationClassStartDate != null)?string.valueOf(Date.valueOf(retirepolicydata.openEnrollmentPopulationClassStartDate).format()):'';
                   groupretirepolicy.throughtRP = (retirepolicydata.openEnrollmentPopulationClassEndDate != null)?string.valueOf(Date.valueOf(retirepolicydata.openEnrollmentPopulationClassEndDate).format()):'';
                   //oACETGroupDetail.groupEligibilityRetirePolicy.add(groupretirepolicy); 
                   oACETGroupDetail.groupEligibilityRetirePolicyTest.add(groupretirepolicy);
                 }
                }
               }
              } 
            }
            
            
            
            system.debug('Customer Account======>'+EGDetails.CustomerAccount);
            if(EGDetails.CustomerAccount != null)
            {    
                for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccount groupeligbility: EGDetails.CustomerAccount){                   
                    if(groupeligbility.CustomerAccountInsuringRules != null){
                        for(ACETGetEmployerGroupAdapterJSON2Apex.CustomerAccountInsuringRules customerAccountInsuring:groupeligbility.CustomerAccountInsuringRules)
                        {   
                            //GroupEligibility Termnation Lag Section
                            ACETGroupDetail.groupEligibilityInfoTermLag groupETermLag = new ACETGroupDetail.groupEligibilityInfoTermLag();
                               groupETermLag.descr = (customerAccountInsuring.terminationLagDescription != null)?customerAccountInsuring.terminationLagDescription:'';
                               groupETermLag.startDate= (customerAccountInsuring.terminationLagStartDate != null)?string.valueOf(Date.valueOf(customerAccountInsuring.terminationLagStartDate).format()):'';                              
                               groupETermLag.endDate= (customerAccountInsuring.terminationLagEndDate !=null)?string.valueOf(Date.valueOf(customerAccountInsuring.terminationLagEndDate).format()):'';
                               oACETGroupDetail.groupEligibilityInfoTermLagList.add(groupETermLag);
                                
                            // GroupEligibility Enrollment waiting Period 
                              ACETGroupDetail.groupEligibilityInfoEnrollWaiting groupEEnrollWaiting = new ACETGroupDetail.groupEligibilityInfoEnrollWaiting();
                               groupEEnrollWaiting.eType = (customerAccountInsuring.newHireWaitingPeriodType != null)?customerAccountInsuring.newHireWaitingPeriodType:'';
                               groupEEnrollWaiting.startDate =(customerAccountInsuring.newHireWaitingStartDate != null)?string.valueOf(Date.valueOf(customerAccountInsuring.newHireWaitingStartDate).format()):'';
                               groupEEnrollWaiting.endDate = (customerAccountInsuring.newHireWaitingEndDate != null)?string.valueOf(Date.valueOf(customerAccountInsuring.newHireWaitingEndDate).format()):'';
                               oACETGroupDetail.groupEligibilityInfoEnrollWaitingList.add(groupEEnrollWaiting);
                               System.debug('New HireWaiting = '+oACETGroupDetail.groupEligibilityInfoEnrollWaitingList); 

                            // GroupEligibility Enrollment DependentCutOff
                               ACETGroupDetail.DependentCutOff groupDependetCutoff = new ACETGroupDetail.DependentCutOff();
                               groupDependetCutoff.cutofAge = (customerAccountInsuring.dependentCutOff != null)?customerAccountInsuring.dependentCutOff:'';
                               groupDependetCutoff.fromGE = (customerAccountInsuring.dependentCutOffStartDate !=null)?string.valueOf(Date.valueOf(customerAccountInsuring.dependentCutOffStartDate).format()):'';
                               groupDependetCutoff.through = (customerAccountInsuring.dependentCutOffEndDate !=null)?string.valueOf(Date.valueOf(customerAccountInsuring.dependentCutOffEndDate).format()):'';
                               oACETGroupDetail.groupEligibilityDependentCutOff.add(groupDependetCutoff);
                               
                            //Group Eligibility Rehire Lag 
                             ACETGroupDetail.rehireLag grouprehireLag = new ACETGroupDetail.rehireLag();
                             grouprehireLag.rule = (customerAccountInsuring.waiveRehiredIndefiniteIndicator != null)?customerAccountInsuring.waiveRehiredIndefiniteIndicator:'';
                             grouprehireLag.count = (customerAccountInsuring.waiveRehiredWithinCount != null)?customerAccountInsuring.waiveRehiredWithinCount:'';
                             grouprehireLag.unit = (customerAccountInsuring.waiveRehiredWithinType != null)?customerAccountInsuring.waiveRehiredWithinType:'';
                             grouprehireLag.fromGE = '';
                             grouprehireLag.through = '';
                             oACETGroupDetail.groupEligibilityRehireLag.add(grouprehireLag);
                            
                        }
                    }
                }
            }
        }

    //Mapping General Group Info Section
    private void generalGroupInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        if (EGDetails != null )
        {   
            oACETGroupDetail.genGroupInfo.groupName = (EGDetails.groupName != Null)?EGDetails.groupName:''; 
            oACETGroupDetail.genGroupInfo.groupId = (EGDetails.groupNumber != Null)?EGDetails.groupNumber:''; 
            taxId = '';
            if(EGDetails.taxIdentificationNumber != null)
            {
                Integer taxIdSize =  EGDetails.taxIdentificationNumber.size();
                for (Integer j = taxIdSize ; j > 0; j--) 
                {
                    //taxId = (taxId == Null)?EGDetails.taxIdentificationNumber[j-1]:taxId + ', ' +EGDetails.taxIdentificationNumber[j-1]; 
                    if(taxId == '' || taxId == null)
                    {
                        taxId = EGDetails.taxIdentificationNumber[j-1];
                    }
                    else
                    {
                        taxId = taxId + ', ' +EGDetails.taxIdentificationNumber[j-1];
                    }
                
                }
            }
            oACETGroupDetail.genGroupInfo.groupTaxId = taxId;
            
            if(EGDetails.customerAccount != null)
            {
                oACETGroupDetail.genGroupInfo.groupStatus = (EGDetails.customerAccount[0].statusDescription != Null)?EGDetails.customerAccount[0].statusDescription:''; 
                
                //oACETGroupDetail.genGroupInfo.groupStatus  = (label.ACETGroupEligibilityStatusToggle == '1')?'Terminate':(label.ACETGroupEligibilityStatusToggle == '2')?'Hold':'Active';
                
                oACETGroupDetail.genGroupInfo.groupRenewalDate = (EGDetails.customerAccount[0].renewalDate != Null)?String.valueof(Date.valueOf(EGDetails.customerAccount[0].renewalDate).format()):''; 
                oACETGroupDetail.genGroupInfo.effectiveStartDate = (EGDetails.customerAccount[0].startDate != Null)?String.valueof(Date.valueOf(EGDetails.customerAccount[0].startDate).format()):''; 
                oACETGroupDetail.genGroupInfo.terminationReason  = (EGDetails.customerAccount[0].terminationReasonDescription != Null )?EGDetails.customerAccount[0].terminationReasonDescription:'';
                oACETGroupDetail.genGroupInfo.terminationDate = (EGDetails.customerAccount[0].terminationDate != Null )?String.valueof(Date.valueOf(EGDetails.customerAccount[0].terminationDate).format()):'';
                oACETGroupDetail.genGroupInfo.effectiveEndDate = (EGDetails.customerAccount[0]!=Null && EGDetails.customerAccount[0].renewalDate != Null)?String.valueof(Date.valueOf(EGDetails.customerAccount[0].renewalDate).addDays(-1).format()):''; 
                                     
                if(EGDetails.customerAccount[0].customerPurchase != null)
                {
                    oACETGroupDetail.genGroupInfo.insured = (EGDetails.customerAccount[0].customerPurchase[0].fundingArrangementDescription != Null )?EGDetails.customerAccount[0].customerPurchase[0].fundingArrangementDescription:'';
                    system.debug('inside Insured --->'+oACETGroupDetail.genGroupInfo.insured);
                }
                system.debug('outside Insured');
            }
            
            oACETGroupDetail.genGroupInfo.groupTeamSize = (EGDetails.sizeDefinitionDescription != Null)?EGDetails.sizeDefinitionDescription:''; 
            oACETGroupDetail.genGroupInfo.UHCBSCOBRA = (EGDetails.cobraAdministrativeIndicator != Null)?EGDetails.cobraAdministrativeIndicator:''; 
            oACETGroupDetail.genGroupInfo.riskManagement = (EGDetails.riskManagementIndicator != Null)?EGDetails.riskManagementIndicator:''; 
            oACETGroupDetail.genGroupInfo.onshoreRestriction = (EGDetails.onshoreRestriction != Null)?EGDetails.onshoreRestriction:''; 
            
            
            if(EGDetails.groupSupportTeamContact != null)
            {
                oACETGroupDetail.genGroupInfo.serviceTeam = (EGDetails.groupSupportTeamContact[0].serviceTeam != Null)?EGDetails.groupSupportTeamContact[0].serviceTeam:''; 
            }
            oACETGroupDetail.genGroupInfo.asianInitIndicator = '';
            system.debug('gen info-----> '+oACETGroupDetail.genGroupInfo);
        }    
    
    }
    
        
    // Mapping Attestations sections 
    private void groupEmployeeCountMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        if (EGDetails != null )
        {
        
            ACETGroupDetail.employeeCountInfo employeeCountInfo = new ACETGroupDetail.employeeCountInfo();
            
            if(EGDetails.employeeCounts != null)
            {
                for(ACETGetEmployerGroupAdapterJSON2Apex.EmployeeCounts addEmpCount:EGDetails.employeeCounts)
                {
                    
                    if(addEmpCount.employeeCountDescription == 'Average Total Number of Employees (ATNE)') 
                        employeeCountInfo.employeeAtne = addEmpCount.employeeCount;
                    if(addEmpCount.employeeCountDescription == 'Total Count of Full Time Employees')
                        employeeCountInfo.fullTime = addEmpCount.employeeCount;
                    if(addEmpCount.employeeCountDescription == 'Part-time')
                        employeeCountInfo.partTime = addEmpCount.employeeCount;
                    if(addEmpCount.employeeCountDescription == 'Total Eligible')
                        employeeCountInfo.totalEligible = addEmpCount.employeeCount;
                    if(addEmpCount.employeeCountDescription == 'Union Eligible')
                        employeeCountInfo.unionEligible = addEmpCount.employeeCount;
                    employeeCountInfo.efectiveFrom = (EGDetails.customerAccount[0]!=Null && EGDetails.customerAccount[0].startDate != Null)?String.valueof(Date.valueOf(EGDetails.customerAccount[0].startDate).format()):'';
                    employeeCountInfo.effectiveThrough = (EGDetails.customerAccount[0]!=Null && EGDetails.customerAccount[0].renewalDate != Null)?String.valueof(Date.valueOf(EGDetails.customerAccount[0].renewalDate).addDays(-1).format()):''; 
                    system.debug('####Inside loop End Employee Count info-----> '+employeeCountInfo);
                                     
                }
                    employeeCountInfo.employeeAtne = (employeeCountInfo.employeeAtne != null)?employeeCountInfo.employeeAtne:'0';
                    employeeCountInfo.fullTime = (employeeCountInfo.fullTime != null)?employeeCountInfo.fullTime:'0';
                    employeeCountInfo.partTime = (employeeCountInfo.partTime != null)?employeeCountInfo.partTime:'0';
                    employeeCountInfo.totalEligible = (employeeCountInfo.totalEligible != null)?employeeCountInfo.totalEligible:'0';
                    employeeCountInfo.unionEligible = (employeeCountInfo.unionEligible != null)?employeeCountInfo.unionEligible:'0';
                    system.debug('####Employee Count info-----> '+employeeCountInfo);
                    oACETGroupDetail.groupEmployeeCountInfoList.add(employeeCountInfo);
            }
        }    
        
    }
    
    // Mapping Address Section
    private void groupAddressMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
    
            
            ACETGroupDetail.AddressInfo addressBillingInfo = new ACETGroupDetail.AddressInfo();
            if(EGDetails.groupAddress != null)
            for(ACETGetEmployerGroupAdapterJSON2Apex.GroupAddress addEGC:EGDetails.groupAddress )
            {  
                if(addEGC.addressTypeCode != null)
                {
                    ACETGroupDetail.AddressInfo addressInfo = new ACETGroupDetail.AddressInfo();  
                    addressInfo.addrType  = (addEGC.addressTypeDescription != null)?addEGC.addressTypeDescription:'';
                    /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -START*/
                    addressInfo.addrLine1  = addEGC.addressLine1;
                    //addressInfo.addrLine2  = addaddr.addressLine2; //Commented by Abhinav
                    addressInfo.city  = addEGC.addressCity;
                    addressInfo.zip  = addEGC.addressPostalCode;
                    addressInfo.state = addEGC.addressStateCode;
                    /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -END*/
                    addressInfo.concatAddrLines='';
                    addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine1!= Null && addEGC.addressLine1!= '')?addEGC.addressLine1:'');
                    addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine2!= Null && addEGC.addressLine2!= '')?', '+addEGC.addressLine2:'');
                    addressInfo.concatAddrLines = addressInfo.concatAddrLines + ((addEGC.addressLine3!= Null && addEGC.addressLine3!= '')?', '+addEGC.addressLine3:'');
                    addressInfo.concatAddrLines = addressInfo.concatAddrLines.removeStart(',');
                    
                    addressInfo.address='';
                    addressInfo.address = addressInfo.address + ((addEGC.addressLine1!= Null && addEGC.addressLine1!= '')?addEGC.addressLine1:'');                    
                    addressInfo.address = addressInfo.address + ((addEGC.addressLine2!= Null && addEGC.addressLine2!= '')?', '+addEGC.addressLine2:'');
                    addressInfo.address = addressInfo.address + ((addEGC.addressLine3!= Null && addEGC.addressLine3!= '')?', '+addEGC.addressLine3:'');
                    addressInfo.address = addressInfo.address + ((addEGC.addressCity!= Null && addEGC.addressCity!= '')?', '+addEGC.addressCity:'');
                    addressInfo.address = addressInfo.address + ((addEGC.addressStateCode!= Null && addEGC.addressStateCode!= '')?', '+addEGC.addressStateCode:'');            
                    addressInfo.address = addressInfo.address + ((addEGC.addressPostalCode!= Null && addEGC.addressPostalCode!= '')?', '+addEGC.addressPostalCode:'');
                    addressInfo.address = addressInfo.address.removeStart(',');             
                    oACETGroupDetail.groupAddressInfoList.add(addressInfo);
               }
             }
      /*   
        if(EGDetails.groupContact  != null )
        {
            ACETGroupDetail.AddressInfo addressInfo = new ACETGroupDetail.AddressInfo();
            ACETGroupDetail.AddressInfo addressBillingInfo = new ACETGroupDetail.AddressInfo();
            
            for(ACETGetEmployerGroupAdapterJSON2Apex.GroupContact addEGC:EGDetails.groupContact )
            {    
                if(addEGC.roleDescription == 'Benefit Administrator' && (addEGC.primaryIndicatorDescription == 'Yes' || addEGC.primaryIndicatorDescription == 'Primary'))
                {
                    for(ACETGetEmployerGroupAdapterJSON2Apex.Address addaddr:addEGC.address )
                    { 
                        if(addaddr.addressTypeCode == 'PLN')
                        {
                            addressInfo.addrType  = 'Primary Address';
                            /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -START*/
                        /*    addressInfo.addrLine1  = addaddr.addressLine1;
                            //addressInfo.addrLine2  = addaddr.addressLine2; //Commented by Abhinav
                            addressInfo.city  = addaddr.addressCity;
                            addressInfo.zip  = addaddr.addressPostalCode;
                            addressInfo.state = addaddr.addressStateCode;
                            /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -END*/
                        /*    addressInfo.address='';
                            addressInfo.address = addressInfo.address + ((addaddr.addressLine1!= Null && addaddr.addressLine1!= '')?addaddr.addressLine1:'');
                            
                            addressInfo.address = addressInfo.address + ((addaddr.addressLine2!= Null && addaddr.addressLine2!= '')?', '+addaddr.addressLine2:'');
                            addressInfo.address = addressInfo.address + ((addaddr.addressLine3!= Null && addaddr.addressLine3!= '')?', '+addaddr.addressLine3:'');
                            addressInfo.address = addressInfo.address + ((addaddr.addressCity!= Null && addaddr.addressCity!= '')?', '+addaddr.addressCity:'');
                            addressInfo.address = addressInfo.address + ((addaddr.addressStateCode!= Null && addaddr.addressStateCode!= '')?', '+addaddr.addressStateCode:'');            
                            addressInfo.address = addressInfo.address + ((addaddr.addressPostalCode!= Null && addaddr.addressPostalCode!= '')?', '+addaddr.addressPostalCode:'');
                                         
                            oACETGroupDetail.groupAddressInfoList.add(addressInfo);
                        }
                    }
            
                }
                
                if(addEGC.roleDescription == 'Billing Contact' && addEGC.RoleType == '2')
                {
                    for(ACETGetEmployerGroupAdapterJSON2Apex.Address addaddr:addEGC.address )
                    { 
                        
                        if(addaddr.addressTypeCode == 'B')
                        {
                            addressBillingInfo.addrType  = 'Billing Address';
                            /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -START*/
                         /*   addressInfo.addrLine1  = addaddr.addressLine1;
                            //addressInfo.addrLine2  = addaddr.addressLine2; //Commented by Abhinav
                            addressInfo.city  = addaddr.addressCity;
                            addressInfo.zip  = addaddr.addressPostalCode;
                            addressInfo.state = addaddr.addressStateCode;
                            /*Uncommented by Vishkaha for Communication call topic want Group Separate Data -END*/
                        /*    addressBillingInfo.address='';
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressLine1!= Null && addaddr.addressLine1!= '')?addaddr.addressLine1:'');
                            
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressLine2!= Null && addaddr.addressLine2!= '')?','+addaddr.addressLine2:'');
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressLine3!= Null && addaddr.addressLine3!= '')?','+addaddr.addressLine3:'');
                            
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressCity!= Null && addaddr.addressCity!= '')?','+addaddr.addressCity:'');
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressStateCode!= Null && addaddr.addressStateCode!= '')?','+addaddr.addressStateCode:'');            
                            addressBillingInfo.address = addressBillingInfo.address + ((addaddr.addressPostalCode!= Null && addaddr.addressPostalCode!= '')?','+addaddr.addressPostalCode:'');
                            oACETGroupDetail.groupAddressInfoList.add(addressBillingInfo);
                        }
                    }
                }
            }
        } */
    }
  
  
    private void groupContactInfoMapping(ACETGetEmployerGroupAdapterJSON2Apex.EmployerGroup EGDetails)
    {
        
        if (EGDetails != null )
        {
            ACETGroupDetail.groupContactInfo employeeGrpInfo = new ACETGroupDetail.groupContactInfo();
            ACETGroupDetail.groupContactInfo adminInfo = new ACETGroupDetail.groupContactInfo();
            list<ACETGroupDetail.contactPhoneInfo> contactPhoneList;
            ACETGroupDetail.contactPhoneInfo contactPhoneInfo;
            ACETGroupDetail.addressInfo contactAddressInfo;
            
            ACETGroupDetail.groupContactInfo groupContactInfo = new ACETGroupDetail.groupContactInfo();
            oACETGroupDetail.groupExternalContactInfoList = new list<ACETGroupDetail.groupContactInfo>();
            oACETGroupDetail.groupExternalContactInfoHistoryList = new list<ACETGroupDetail.groupContactInfo>();
            oACETGroupDetail.groupInternalContactInfoList = new list<ACETGroupDetail.groupContactInfo>();
            
            if(EGDetails.groupContact != null)
            {  
                for(ACETGetEmployerGroupAdapterJSON2Apex.GroupContact contactData:EGDetails.groupContact)
                {
                    
                    if(contactData != Null && contactData.address != Null)
                    {
                      for(ACETGetEmployerGroupAdapterJSON2Apex.Address addrInfo:contactData.address )
                      {
                        adminInfo = new ACETGroupDetail.groupContactInfo();
                        adminInfo.contactPhones = new list<ACETGroupDetail.contactPhoneInfo>();
                        adminInfo.contactAddress = new list<ACETGroupDetail.AddressInfo>();
                        adminInfo.contactEmails = new list<String>();
                       
                        
                        adminInfo.primaryContactType = (contactData.roleDescription != Null)?contactData.roleDescription:adminInfo.primaryContactType ;
                        
                        adminInfo.firstName = (contactData.firstName != Null)?contactData.firstName:adminInfo.firstName;
                        adminInfo.LastName = (contactData.lastName != Null)?contactData.lastName:adminInfo.LastName;
                        adminInfo.middleName = (contactData.middleName != Null)?contactData.middleName:adminInfo.middleName;
                        
                        adminInfo.startDate = (contactData.startDate != Null)?String.valueof(Date.valueOf(contactData.startDate).format()):adminInfo.startDate;
                        adminInfo.endDate = (contactData.endDate != Null)?String.valueof(Date.valueOf(contactData.endDate).format()):adminInfo.endDate;
                        
                        if(contactData.address != Null)
                        {
                          /* contactAddressInfo = new ACETGroupDetail.addressInfo();
                                contactAddressInfo.addrLine1 = (addrInfo.addressLine1 != Null)?addrInfo.addressLine1:contactAddressInfo.addrLine1 ;
                                contactAddressInfo.addrType = (addrInfo.addressTypeDescription != Null)?addrInfo.addressTypedescription:contactAddressInfo.addrType;
                                contactAddressInfo.addrLine2 = (addrInfo.addressLine2 != Null)?addrInfo.addressLine2:contactAddressInfo.addrLine2 ;
                                contactAddressInfo.addrLine3 = (addrInfo.addressLine3 != Null)?addrInfo.addressLine3:contactAddressInfo.addrLine3 ;
                                
                                contactAddressInfo.City = (addrInfo.addressCity != Null)?addrInfo.addressCity :contactAddressInfo.City;
                                contactAddressInfo.State = (addrInfo.addressStateCode != Null)?addrInfo.addressStateCode :contactAddressInfo.State;
                                contactAddressInfo.Zip = (addrInfo.addressPostalCode != Null)?addrInfo.addressPostalCode :contactAddressInfo.Zip; 
                        
                                if(contactAddressInfo != Null)
                                adminInfo.contactAddress.add(contactAddressInfo);*/
                            
                             
                                adminInfo.address = '';
                                adminInfo.address = adminInfo.address + ((addrInfo.addressLine1 != Null && addrInfo.addressLine1 != '')?addrInfo.addressLine1:'');
                                adminInfo.address = adminInfo.address + ((addrInfo.addressLine2 != Null && addrInfo.addressLine2 != '')?','+addrInfo.addressLine2:'');
                                adminInfo.address = adminInfo.address + ((addrInfo.addressLine3 != Null && addrInfo.addressLine3 != '')?','+addrInfo.addressLine3:'');
                                adminInfo.address = adminInfo.address + ((addrInfo.addressCity != Null && addrInfo.addressCity != '')?','+addrInfo.addressCity:'');
                                adminInfo.address = adminInfo.address + ((addrInfo.addressStateCode != Null && addrInfo.addressStateCode != '')?','+addrInfo.addressStateCode:'');
                                adminInfo.address = adminInfo.address + ((addrInfo.addressPostalCode != Null && addrInfo.addressPostalCode != '')?','+addrInfo.addressPostalCode:'');
                                adminInfo.addressType = (addrInfo.addressTypeDescription != null)?addrInfo.addressTypeDescription:'';
                                
                            
                        }
                        
                        if(contactData.primaryIndicatorDescription == 'Yes'  || contactData.primaryIndicatorDescription == 'Primary')
                        {
                            adminInfo.contactType = 'Primary';
                        }else
                        {
                          adminInfo.contactType = 'Additional';
                        }
                        
                        
                        if(contactData.phone != Null)
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Phone_Z phoneInfo:contactData.phone)
                            {
                                contactPhoneInfo = new ACETGroupDetail.contactPhoneInfo();
                                contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                                contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension != Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt ;
                                contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                                
                                if(contactPhoneInfo != Null)
                                adminInfo.contactPhones.add(contactPhoneInfo);
                            }
                            if(adminInfo.contactPhones != Null)
                            adminInfo.Phone = adminInfo.contactPhones[0].phoneNumber ;
                        }
                        
                        if(contactData.email != Null)
                        {
                            for(ACETGetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
                            {
                                if(emailInfo.electronicAddress != Null)
                                adminInfo.contactEmails.add(emailInfo.electronicAddress);
                            }
                            if(adminInfo.contactEmails != Null)
                            adminInfo.EmailAddress = adminInfo.contactEmails[0];
                        
                        }
                        
                        if(contactData.endDate != Null && contactData.startDate != Null && date.today().daysBetween(Date.valueOf(contactData.endDate)) > 0 &&  Date.valueOf(contactData.startDate).daysBetween(date.today()) > 0)
                        {
                            adminInfo.activeStatus = 'Y';                    
                        }else
                        {
                            adminInfo.activeStatus = 'N';                    
                        }
                        
                        if(adminInfo.activeStatus == 'Y' )
                        {
                            oACETGroupDetail.groupExternalContactInfoList.add(adminInfo);
                        }
                        else if(adminInfo.activeStatus == 'N' )
                        {
                            oACETGroupDetail.groupExternalContactInfoHistoryList.add(adminInfo);
                        }
                       } 
                    }
                    //
                }
            }
            
           if(EGDetails.groupSupportTeamContact != null){
            for(ACETGetEmployerGroupAdapterJSON2Apex.GroupSupportTeamContact contactData:EGDetails.groupSupportTeamContact)
            {
                if(contactData != Null)
                {
                       
                    employeeGrpInfo = new ACETGroupDetail.groupContactInfo();
                    employeeGrpInfo.contactPhones = new list<ACETGroupDetail.contactPhoneInfo>();
                    employeeGrpInfo.contactEmails = new list<String>();
                   // ACETGroupDetail.contactPhoneInfo contactPhoneInfo;
                    employeeGrpInfo.primaryContactType = contactData.roleDescription;
                    
                    employeeGrpInfo.firstName = ( contactData.firstName != Null)?contactData.firstName:employeeGrpInfo.firstName;
                    employeeGrpInfo.LastName = ( contactData.lastName != Null)?contactData.lastName:employeeGrpInfo.LastName;
                    employeeGrpInfo.middleName = ( contactData.middleName != Null)?contactData.middleName:employeeGrpInfo.middleName;
                    
                    employeeGrpInfo.startDate = (contactData.startDate != Null)?String.valueof(Date.valueOf(contactData.startDate).format()):employeeGrpInfo.startDate;
                    employeeGrpInfo.endDate = (contactData.endDate != Null)?String.valueof(Date.valueOf(contactData.endDate).format()):employeeGrpInfo.endDate;
                    if(contactData.phone != Null)
                    {
                        for(ACETGetEmployerGroupAdapterJSON2Apex.Phone_Y phoneInfo:contactData.phone)
                        {
                            contactPhoneInfo = new ACETGroupDetail.contactPhoneInfo();
                            contactPhoneInfo.phoneType = (phoneInfo != Null && phoneInfo.phoneType != Null)?phoneInfo.phoneType:contactPhoneInfo.phoneType;
                            contactPhoneInfo.phoneNumber = (phoneInfo != Null && phoneInfo.telephoneNumber != Null)?phoneInfo.telephoneNumber:contactPhoneInfo.phoneNumber ;
                            contactPhoneInfo.phoneExt = (phoneInfo != Null && phoneInfo.phoneExtension!= Null)?phoneInfo.phoneExtension:contactPhoneInfo.phoneExt;
                            if(contactPhoneInfo != Null)
                            employeeGrpInfo.contactPhones.add(contactPhoneInfo);
                        }
                        if(employeeGrpInfo.contactPhones != Null)
                        {
                        employeeGrpInfo.extension = employeeGrpInfo.contactPhones[0].phoneExt;
                        employeeGrpInfo.Phone = employeeGrpInfo.contactPhones[0].phoneNumber;
                        }
                    }
                    
                    if(contactData.email != Null)
                    {
                        for(ACETGetEmployerGroupAdapterJSON2Apex.Email emailInfo:contactData.email)
                        {
                            if(emailInfo.electronicAddress != Null)
                            employeeGrpInfo.contactEmails.add(emailInfo.electronicAddress);
                        }
                        if(employeeGrpInfo.contactEmails != Null)
                        employeeGrpInfo.EmailAddress = employeeGrpInfo.contactEmails[0];
                    }
                    oACETGroupDetail.groupInternalContactInfoList.add(employeeGrpInfo);
                                
                }
            }
           }
            
        } 
        
                
    }
    //Please don't remove this code. It is using in group plan controller - divya    
    public ACETWSCalloutResult getEmployerGroupDetail(string groupNumber){
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        ACETGroupDetail oACETGroupDetail;
        
        try
        {
            GetEndpoint();
            relativeURL = '/api/alpha/eisl/organizations/employergroups/v2.0/read';
            GetRequestBody(groupNumber);
            HttpResponse Response = Send(OAuthConfig);
            system.debug('Response----->'+Response);
            if (Response.getStatusCode() == 200)
            {
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                //String strResponse = ACETTestDataUtility.getEmployerResponseforAgeBand();
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));
                //oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(strResponse));
            }
            else
            {
                oACETWSCalloutResult = ParseFailureResponse(Response);        
            }
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in GetEmployer. Details: ' + ex + ex.getLineNumber() +ex.getMessage()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }
    
    
    
    public Continuation StartRequest(string groupNumber, String CallbackMethodName, Continuation oContinuation)
    {
        GetEndpoint();
        relativeURL = '/api/alpha/eisl/organizations/employergroups/v2.0/read';
        GetRequestBody(groupNumber);
        oContinuation = AddHttpRequest(OAuthConfig, CallbackMethodName, oContinuation);
        Long dt1Long = DateTime.now().getTime();
        system.debug('date11111111111111'+dt1Long);
        return oContinuation;         
    }
    
    public ACETWSCalloutResult ProcessResponse(String HttpRequestLabel) {
        ACETWSCalloutResult oACETWSCalloutResult = new ACETWSCalloutResult();
        try {
            HttpResponse Response = GetHttpResponse(HttpRequestLabel);
            if (Response.getStatusCode() == 200) {
            system.debug('Response.getBody()----->'+Response.getBody());
                oACETWSCalloutResult.Success = true;
                oACETWSCalloutResult.Message = '';
                oACETWSCalloutResult.Response = parseSuccessAdapterResponse(ReplaceKeywords(Response.getBody()));  
            } else {
              oACETWSCalloutResult = ParseFailureResponse(Response);  
            }  
            Long dt2Long = DateTime.now().getTime();
            system.debug('oACETWSCalloutResult---->'+oACETWSCalloutResult);
        }
        catch(Exception ex)
        {
            system.debug(LoggingLevel.INFO, 'Exception in ProcessResponse. Details: ' + ex.getstackTraceString()); 
            oACETWSCalloutResult.Success = false;
            oACETWSCalloutResult.Message = ex.getMessage();
            oACETWSCalloutResult.MessageSeverity = ApexPages.Severity.ERROR;
        }
        system.debug('oACETWSCalloutResult: ' + oACETWSCalloutResult);        
        return oACETWSCalloutResult;
    }   
}