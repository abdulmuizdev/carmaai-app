abstract class CatagWiseAmountEvent {
  const CatagWiseAmountEvent();
}

class FetchCatagWiseAmount extends CatagWiseAmountEvent {
  final String fromDate;
  final String toDate;
  const FetchCatagWiseAmount(this.fromDate, this.toDate);
}
