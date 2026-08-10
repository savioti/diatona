import '../../../features/scale_trainer/presentation/scale_labels.dart';
import '../../l10n/generated/app_localizations.dart';
import '../domain/cadence_type.dart';
import '../domain/harmonic_function.dart';
import '../domain/harmonic_key.dart';
import '../domain/progression_tempo.dart';

/// `Db Major`, `C# Harmonic Minor`: the tonic and the scale it carries.
String harmonicKeyName(HarmonicKey key, AppLocalizations l10n) =>
    l10n.trainingRootLabel(key.root, scaleTypeName(key.scale, l10n));

String harmonicFunctionName(HarmonicFunction function, AppLocalizations l10n) =>
    switch (function) {
      HarmonicFunction.tonic => l10n.refFnTonic,
      HarmonicFunction.subdominant => l10n.refFnSubdominant,
      HarmonicFunction.dominant => l10n.refFnDominant,
    };

String progressionTempoName(ProgressionTempo tempo, AppLocalizations l10n) =>
    switch (tempo) {
      ProgressionTempo.slow => l10n.refProgressionsSlow,
      ProgressionTempo.medium => l10n.refProgressionsMedium,
      ProgressionTempo.fast => l10n.refProgressionsFast,
    };

String cadenceTypeName(CadenceType cadence, AppLocalizations l10n) =>
    switch (cadence) {
      CadenceType.authentic => l10n.cadenceAuthentic,
      CadenceType.plagal => l10n.cadencePlagal,
      CadenceType.half => l10n.cadenceHalf,
      CadenceType.deceptive => l10n.cadenceDeceptive,
    };
