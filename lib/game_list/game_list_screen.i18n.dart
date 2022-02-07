import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en") +
      {
        "en": "Select an item in the list",
        "es": "Seleccione un elemento de la lista",
        "fr": "Sélectionnez un élément dans la liste",
      } +
      {
        "en": "Close",
        "es": "Cerrar",
        "fr": "Fermer",
      } +
      {
        "en": "Initializing...",
        "es": "Inicializando...",
        "fr": "Initialisation...",
      } +
      {
        "en": "The process has completed successfully.",
        "es": "El proceso ha finalizado con éxito.",
        "fr": "Le processus a réussi.",
      } +
      {
        "en": "An error has occurred, please try again later.",
        "es": "Ha ocurrido un error, por favor inténtelo de nuevo más tarde.",
        "fr": "Une erreur est survenue, veuillez réessayer plus tard.",
      } +
      {
        "en": "Download all images and descriptions",
        "es": "Descargar todas las imágenes y descripciones",
        "fr": "Télécharger toutes les images et descriptions",
      };

  String get i18n => localize(this, _t);
}
