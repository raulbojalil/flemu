import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en": "Error loading description",
        "es": "Error al cargar la descripción",
        "fr": "Une erreur est survenue lors du chargement de la description",
      } +
      {
        "en": "Loading image...",
        "es": "Cargando imagen...",
        "fr": "Chargement de l'image...",
      } +
      {
        "en": "Loading description...",
        "es": "Cargando descripción...",
        "fr": "Chargement de la description...",
      } +
      {
        "en": "No description available",
        "es": "No hay descripción disponible",
        "fr": "Aucune description disponible",
      } +
      {
        "en": "PLAY",
        "es": "JUGAR",
        "fr": "JOUER",
      };

  String get i18n => localize(this, _t);
}
