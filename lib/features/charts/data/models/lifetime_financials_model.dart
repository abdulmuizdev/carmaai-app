import 'package:carma/features/charts/domain/entities/lifetime_financials_entity.dart';

class LifetimeFinancialsModel extends LifetimeFinancialsEntity {
  final String lifeTimeExpenses;
  final String lifeTimeIncome;
  final String lifeTimeBalance;

  const LifetimeFinancialsModel({
    required this.lifeTimeExpenses,
    required this.lifeTimeIncome,
    required this.lifeTimeBalance,
  }) : super(lifeTimeExpenses: lifeTimeExpenses, lifeTimeIncome: lifeTimeIncome, lifeTimeBalance: lifeTimeBalance);
}
