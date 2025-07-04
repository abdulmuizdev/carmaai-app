abstract class MonthWiseFinancialsEvent {
  const MonthWiseFinancialsEvent();
}

class FetchMonthWiseFinancials extends MonthWiseFinancialsEvent {
  const FetchMonthWiseFinancials();
}

class FetchLifeTimeFinancials extends MonthWiseFinancialsEvent {
  const FetchLifeTimeFinancials();
}
