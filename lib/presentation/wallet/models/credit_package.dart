import 'package:clever/l10n/generated/app_localizations.dart';

class CreditPackage {
  final String id;
  final int credits;
  final String Function(AppLocalizations l10n) nameBuilder;
  final String priceIdr;
  final String priceUsd;
  final String perCreditIdr;
  final String perCreditUsd;
  final int? savingsPercent;
  final bool isPopular;

  const CreditPackage({
    required this.id,
    required this.credits,
    required this.nameBuilder,
    required this.priceIdr,
    required this.priceUsd,
    required this.perCreditIdr,
    required this.perCreditUsd,
    this.savingsPercent,
    this.isPopular = false,
  });
}
