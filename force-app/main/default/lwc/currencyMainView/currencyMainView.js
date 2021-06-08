import { api, LightningElement, wire } from "lwc";
import { refreshApex } from "@salesforce/apex";
import getExistingTrades
  from "@salesforce/apex/CurrencyController.getExistingTrades";

import TABLE_TITLE_LABEL from "@salesforce/label/c.Existing_Exchange_Trades";
import NEW_TRADE_LABEL from "@salesforce/label/c.New_Trade";

const REGISTRATOR_COLUMNS = [
  {
    label: "Sell CCY",
    fieldName: "Sell_Currency__c"
  },
  {
    label: "Sell Amount",
    fieldName: "Sell_Amount__c"
  },
  {
    label: "Buy Currency",
    fieldName: "Buy_Currency__c"
  },
  {
    label: "Buy Amount",
    fieldName: "Buy_Amount__c"
  },
  {
    label: "Rate",
    fieldName: "Rate__c"
  },
  {
    label: "Date Booked",
    fieldName: "CreatedDate",
    type: "date",
    typeAttributes: {
      year: "numeric",
      month: "numeric",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    }
  }
];
export default class CurrencyMainView extends LightningElement {
  @api recordId;

  data;
  columns = REGISTRATOR_COLUMNS;
  isLoading = true;
  showCreateTradeModal;
  labels = {
    "tableTitle": TABLE_TITLE_LABEL,
    "newTrade": NEW_TRADE_LABEL
  };

  @wire(getExistingTrades)
  loadTrades(trades) {
    this.wiredTrades = trades;
    if (trades.data) {
      this.data = trades.data;
      this.isLoading = false;
    } else if (trades.error) {
      console.log("ERROR: ", trades.error);
    }
  }

  handleCreateTrade() {
    this.showCreateTradeModal = true;
  }

  hancleCloseModal() {
    refreshApex(this.wiredTrades);
    this.showCreateTradeModal = false;
  }
}