public with sharing class CurrencyController {

	@AuraEnabled(cacheable=true)
	public static CurrencyService.CurrencyDocumentResponseModel getCurrencyData() {
		try {
			CurrencyService.CurrencyDocumentResponseModel result = CurrencyService.getCurrencyResponse();
			return result;
		} catch( Exception e ) {
			throw new AuraHandledException( e.getMessage() );
		}
	}

	@AuraEnabled(cacheable=true)
	public static List<Trade__c> getExistingTrades() {
		List<Trade__c> tradesList = [
				SELECT Id,
						Sell_Currency__c,
						Sell_Amount__c,
						Buy_Currency__c,
						Buy_Amount__c,
						Rate__c,
						CreatedDate
				FROM Trade__c
				ORDER BY CreatedDate DESC
		];

		return tradesList;
	}

	@AuraEnabled
	public static CurrencyService.CurrencyCalculateResponseModel calculate( String currencyFrom, String currencyTo, String currencyAmount ) {
		CurrencyService.CurrencyCalculateResponseModel result = CurrencyService.getCalculationResultService( currencyFrom, currencyTo, currencyAmount );

		return result;
	}

	@AuraEnabled
	public static void createTrade( String sellCCY, String sellAmount, String buyCurrency, String buyAmount, String rate ) {
		try {
			Trade__c newTrade = new Trade__c();
			newTrade.Sell_Currency__c = sellCCY;
			newTrade.Sell_Amount__c = double.valueOf( sellAmount );
			newTrade.Buy_Currency__c = buyCurrency;
			newTrade.Buy_Amount__c = double.valueOf( buyAmount );
			newTrade.Rate__c = double.valueOf( rate );

			insert newTrade;
		} catch( Exception e ) {	
			System.debug('e: ' + e);
			throw new AuraHandledException( e.getMessage() );
		}
	}
}