global class ACETDeleteResearchInteractionSchdule implements Schedulable{
    global void execute(SchedulableContext SC) {
        ACETDeleteResearchInteractionBatch batchClass = new ACETDeleteResearchInteractionBatch();
        Database.ExecuteBatch(batchClass);
           
        String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        
        Integer hour = Integer.Valueof(system.now().hour() + Integer.valueof(Label.ACETResearchInteractionBatchHour));
        
        String actualHour = String.valueof(hour > 23 ? hour - 24 : hour);
        String minute = string.valueOf(system.now().minute());
        String second = string.valueOf(system.now().second());
        String year = string.valueOf(system.now().year());
        
        String strJobName = 'Job-' + second + '_' + minute + '_' + actualHour + '_' + day + '_' + month + '_' + year;
        String strSchedule = '0 ' + minute + ' ' + actualHour + ' ' + day + ' ' + month + ' ?' + ' ' + year;
        System.schedule(strJobName, strSchedule, new ACETDeleteResearchInteractionSchdule ());
    } 
}