import { api, LightningElement } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getCurrencies from "@salesforce/apex/CurrencyController.getCurrencyData";
import calculateInputs from "@salesforce/apex/CurrencyController.calculate";
import createTrade from "@salesforce/apex/CurrencyController.createTrade";
import lib from "c/lib";

export default class CreateTradeModal extends LightningElement {
  @api
  get openModal() {
    return this._openModal;
  }

  set openModal(value) {
    if (value === true) {
      this.getServiceResponse(); // Request the Service everytime modal is opened.
      this.isModalOpen = true;
    } else if (value === false) {
      this.isModalOpen = false;
    }
  }

  isModalOpen = false;
  isLoading = true;
  sellComboValue;
  sellSelectedLabel;
  sellInputValue;
  buyComboValue;
  buySelectedLabel;
  buyInputValue;
  fetchedCurrencyRate;

  getServiceResponse() {
    getCurrencies().then(fetchedCurrencies => {
      console.log(fetchedCurrencies);
      this.sellCurrencyOption = lib.getCurrencyAsOption(fetchedCurrencies?.rates); //JS functions are stored in external custom library. When is possible.
      this.buyCurrencyOption = lib.getCurrencyAsOption(fetchedCurrencies?.rates); //Trying to keep the code clean.
      this.isLoading = false;
    }).catch(e => {
      const errorEvent = new ShowToastEvent({  //Usually put events body in 'lib' file. Put them in function and call only title,message,variant; 
                                              title: "Error",
                                              message: "Problem with the form. Contact the support.",
                                              variant: "error"
                                            });
      this.dispatchEvent(errorEvent);
      this.handleCloseModal();
      console.log("ERROR => getServiceResponse.getCurrencies: ", e);
    });
  }

  handleSellComboboxChange(event) {
    this.sellSelectedLabel = event.target.options.find(opt => opt.value === event.detail.value).label; //Could be in the library.
    this.sellComboValue = event.detail.value;
    this.validateFields();
  }

  handleSellInputChange(event) {
    this.sellInputValue = event.detail.value;
  }

  handleBuyComboboxChange(event) {
    this.buySelectedLabel = event.target.options.find(opt => opt.value === event.detail.value).label;
    this.buyComboValue = event.detail.value;
    this.validateFields();
  }

  validateFields() {
    if (this.sellComboValue != null &&
        this.buyComboValue != null &&
        this.sellInputValue != null) {
      this.fetchCurrencyRate();
    }
  }

  fetchCurrencyRate() {
    this.isLoading = true;
    const params = {
      currencyFrom: this.sellSelectedLabel,
      currencyTo: this.buySelectedLabel,
      currencyAmount: this.sellInputValue
    };

    calculateInputs(params).then(response => {
      this.populateFieldsAfterResponse(response);
    }).catch(e => {
      const errorEvent = new ShowToastEvent({
                                              title: "Error",
                                              message: "There is a problem with the service. Contact the support.",
                                              variant: "error"
                                            });
      this.dispatchEvent(errorEvent);
      console.log("ERROR => fetchCurrencyRate.calculateInputs: ", e);
    });
  }

  populateFieldsAfterResponse(data) {
    this.fetchedCurrencyRate = data?.info?.rate;
    this.buyInputValue = data.result;
    this.isLoading = false;
  }

  handleCloseModal() {
    this.dispatchEvent(new CustomEvent("closemodal"));
    this.buyComboValue = undefined;
    this.buyInputValue = undefined;
    this.sellComboValue = undefined;
    this.sellInputValue = undefined;
    this.fetchedCurrencyRate = undefined;
    this.isLoading = false;
  }

  handleCreateTrade() {
    this.isLoading = true;
    const params = {
      sellCCY: this.sellSelectedLabel,
      sellAmount: this.sellInputValue,
      buyCurrency: this.buySelectedLabel,
      buyAmount: this.buyInputValue,
      rate: this.fetchedCurrencyRate
    };

    createTrade(params).then(() => {
      const successEvent = new ShowToastEvent({
                                                title: "Success",
                                                message: "Trade successfully created",
                                                variant: "success"
                                              });

      this.dispatchEvent(successEvent);
      this.handleCloseModal();
    }).catch(e => {
      console.log("error: ", e);
    });
  }

}