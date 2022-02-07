import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en": "Search",
        "es": "Buscar",
        "fr": "Rechercher",
      };

  String get i18n => localize(this, _t);
}
