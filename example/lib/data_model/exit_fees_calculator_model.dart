const exitFeesCalculatorModel = {
  "question": "Calculate exit fees for your mutual fund",
  "inputValues": {
    "NAV at time of investment": "",
    "Total Investment": "",
    "Current NAV": "",
    "Redemption Amount": ""
  },
  "program":
      "((CURRENT_NAV - NAV_AT_INVESTMENT) / NAV_AT_INVESTMENT) * TOTAL_INVESTMENT * (EXIT_FEE_PERCENTAGE / 100)"
};
