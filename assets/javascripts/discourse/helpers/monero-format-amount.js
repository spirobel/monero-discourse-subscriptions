import Helper from "@ember/component/helper";

export default Helper.helper(function (params) {
  let currencySign;
  switch (params[1]) {
    case "EUR":
    case "eur":
      currencySign = "€";
      break;
    case "GBP":
    case "gbp":
      currencySign = "£";
      break;
    case "INR":
    case "inr":
      currencySign = "₹";
      break;
    case "BRL":
    case "brl":
      currencySign = "R$";
      break;
    case "DKK":
    case "dkk":
      currencySign = "DKK";
      break;
    case "SGD":
    case "sgd":
      currencySign = "S$";
      break;
    default:
      currencySign = "$";
  }

  return parseFloat(params[0]).toFixed(2) + " " + currencySign ;
});