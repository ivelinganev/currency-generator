@IsTest
private class CurrencyController_Test {

	@IsTest
	public static void getExistingTrades_Test() {
		List<Trade__c> tradesList = CurrencyController.getExistingTrades();

		System.assertEquals( 0, tradesList.size() );
	}

	@IsTest(SeeAllData=true)
	public static void createTrade_Test() {
		Test.startTest();
		CurrencyController.createTrade( 'EUR', '115', 'BGN', '223', '1.95583' );
		Test.stopTest();
	}

	@IsTest
	public static void getCurrencyData_Test() {
		CurrencyService.CurrencyDocumentResponseModel responseModel;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'GetCurrencies' );
		mock.setStatusCode( 200 );
		mock.setHeader( 'Content-Type', 'application/json;charset=UTF-8' );
		Test.setMock( HttpCalloutMock.class, mock );

		Test.startTest();

		responseModel = CurrencyController.getCurrencyData();

		Test.stopTest();

		System.assertEquals( responseModel.base, 'EUR' );
		System.assertNotEquals( responseModel.rates, NULL );
		System.assertEquals( responseModel.success, true );
	}

	@IsTest
	public static void calculate_Test() {
		CurrencyService.CurrencyCalculateResponseModel responseModel;

		StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
		mock.setStaticResource( 'CurrenciesCalc' );
		mock.setStatusCode( 200 );
		mock.setHeader( 'Content-Type', 'application/json;charset=UTF-8' );
		Test.setMock( HttpCalloutMock.class, mock );

		Test.startTest();

		responseModel = CurrencyController.calculate( 'GBP', 'JPY', '25' );

		Test.stopTest();
	}
}