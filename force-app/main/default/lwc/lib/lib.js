function getCurrencyAsOption(currencies) {

  if (!currencies) {
    return;
  }

  let options = [];
  for (let key in currencies) {
    let uniqueValue = `${currencies[key]}-${key}`;
    let currentCurrency = { label: key, value: uniqueValue };
    options.push(currentCurrency);
  }

  return options;
}

export {
  getCurrencyAsOption
};