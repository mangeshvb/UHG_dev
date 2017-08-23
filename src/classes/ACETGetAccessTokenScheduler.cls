public class ACETGetAccessTokenScheduler implements Schedulable {
	public void execute(SchedulableContext sc) {
		Database.executeBatch(new ACETGetAccessTokenBatch(), 1);					
	}
	
	//Run following block of statements in Developer Console to schedule batch job it run after every 30 minutes
	/*
		ACETGetAccessTokenScheduler ACETGATScheduler = new ACETGetAccessTokenScheduler();
		String HourCronExpr = '0 0 * * * ?';
		String HalfHourCronExpr = '0 30 * * * ?';
		System.schedule('ACET Get Access Token Hourly Job', HourCronExpr, ACETGATScheduler);
		System.schedule('ACET Get Access Token Half Hourly Job', HalfHourCronExpr, ACETGATScheduler);
	*/	
}