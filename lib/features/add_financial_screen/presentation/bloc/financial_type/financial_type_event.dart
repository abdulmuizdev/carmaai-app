abstract class FinancialTypeEvent {
  const FinancialTypeEvent();
}

class FetchIncomeTypes extends FinancialTypeEvent {
  const FetchIncomeTypes();
}

class FetchExpenseTypes extends FinancialTypeEvent {
  const FetchExpenseTypes();
}