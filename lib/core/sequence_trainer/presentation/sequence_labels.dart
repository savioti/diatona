import '../../l10n/generated/app_localizations.dart';
import '../domain/sequence_direction.dart';

String sequenceDirectionName(
  SequenceDirection direction,
  AppLocalizations l10n,
) =>
    switch (direction) {
      SequenceDirection.ascending => l10n.trainingAscending,
      SequenceDirection.descending => l10n.trainingDescending,
      SequenceDirection.upAndDown => l10n.trainingUpAndDown,
    };

String trainingKeysName(bool naturalRootsOnly, AppLocalizations l10n) =>
    naturalRootsOnly ? l10n.trainingKeysNaturals : l10n.trainingKeysAll;
