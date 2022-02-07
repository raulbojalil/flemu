import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en":
            "An error has occurred. Please check your connection and try again.",
        "es":
            "Ha ocurrido un error. Por favor, compruebe su conexión a internet e inténtelo de nuevo.",
        "fr":
            "Une erreur est survenue. Veuillez vérifier votre connexion et réessayer.",
      };

  String get i18n => localize(this, _t);
}
