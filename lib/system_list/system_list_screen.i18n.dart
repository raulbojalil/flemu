import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en": "Select a system",
        "es": "Seleccione un sistema",
        "fr": "Choisissez un système",
      } +
      {
        "en": "Language",
        "es": "Idioma",
        "fr": "Langue",
      };

  String get i18n => localize(this, _t);
}
