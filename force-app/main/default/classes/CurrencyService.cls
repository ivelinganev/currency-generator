global with sharing class CurrencyService {

	public class CurrencyDocumentResponseModel {
		@AuraEnabled
		public Boolean success { get; set; }
		@AuraEnabled
		public Integer timestamp { get; set; }
		@AuraEnabled
		public String base { get; set; }
		@AuraEnabled
		public Map<String, String> rates { get; set; }
	}

	public class CurrencyCalculateResponseModel {
		@AuraEnabled
		public Boolean success { get; set; }
		@AuraEnabled
		public Map<String, String> query { get; set; }
		@AuraEnabled
		public Map<String, String> info { get; set; }
		@AuraEnabled
		public String result { get; set; }
	}

	public static CurrencyDocumentResponseModel getCurrencyResponse() {
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setEndpoint( 'http://data.fixer.io/api/latest?access_key=fda3f278717e6200f6162a93152e7bc4&format=1' );
		httpRequest.setMethod( 'POST' );

		Http http = new Http();
		HttpResponse httpResponse = http.send( httpRequest );
		String responseBody = httpResponse.getBody();
		CurrencyDocumentResponseModel documentResponse = ( CurrencyDocumentResponseModel ) JSON.deserialize( responseBody, CurrencyDocumentResponseModel.class );

		return documentResponse;
	}

	public static CurrencyCalculateResponseModel getCalculationResultService( String currencyFrom, String currencyTo, String currencyAmount ) {
		String params = '&from=' + currencyFrom + '&to=' + currencyTo + '&amount=' + currencyAmount;
		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setEndpoint( 'http://data.fixer.io/api/convert?access_key=fda3f278717e6200f6162a93152e7bc4&format=1' + params );
		httpRequest.setMethod( 'POST' );

		Http http = new Http();
		HttpResponse httpResponse = http.send( httpRequest );
		String responseBody = httpResponse.getBody();
		System.debug( '@responseBody: ' + responseBody );
		CurrencyCalculateResponseModel calculationResponse = ( CurrencyCalculateResponseModel ) JSON.deserialize( responseBody, CurrencyCalculateResponseModel.class );

		return calculationResponse;
	}
}