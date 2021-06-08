@IsTest
private class CurrencyController_Test {

	@testSetup
	private static void setupTestdata() {
		Trade__c trd = new Trade__c();
		trd.Sell_Currency__c = 'GBP';
		trd.Sell_Amount__c = 256;
		trd.Buy_Currency__c = 'EUR';
		trd.Buy_Amount__c = 198;
		trd.Rate__c = 1.10;

		insert trd;

	}

	@IsTest
	public static void getExistingTrades_Test() {
		List<Trade__c> tradesList = CurrencyController.getExistingTrades();

		System.assertEquals( 1, tradesList.size() );
	}

	@IsTest
	public static void createTrade_Test() {
		List<Trade__c> tradesList = CurrencyController.getExistingTrades();
		System.assertEquals( 1, tradesList.size() );

		CurrencyController.createTrade( 'EUR', '115', 'BGN', '223', '1.95583' );

		System.assertEquals( 2, [ SELECT Id FROM Trade__c ].size() );
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