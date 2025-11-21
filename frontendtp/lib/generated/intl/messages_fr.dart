// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(error) => "Erreur de connexion : ${error}";

  static String m1(error) => "Erreur de connexion : ${error}";

  static String m2(error) => "Erreur lors de la création : ${error}";

  static String m3(date) => "Date Limite: ${date}";

  static String m4(date) => "Date limite : ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addImage": MessageLookupByLibrary.simpleMessage("Ajouter image : "),
    "addTask": MessageLookupByLibrary.simpleMessage("Ajouter la tâche"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Application Todo"),
    "changeProgress": MessageLookupByLibrary.simpleMessage(
      "Changer progression : ",
    ),
    "chooseDeadline": MessageLookupByLibrary.simpleMessage(
      "Choisir une date limite",
    ),
    "chooseImage": MessageLookupByLibrary.simpleMessage("Choisir une image"),
    "confirmPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Confirmez votre mot de passe",
    ),
    "connectionError": m0,
    "connectionErrorWithDetails": m1,
    "connectionTitle": MessageLookupByLibrary.simpleMessage("Connexion"),
    "consultationTitle": MessageLookupByLibrary.simpleMessage("Consultation"),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continuer"),
    "creationError": m2,
    "creationTitle": MessageLookupByLibrary.simpleMessage("Création de tâche"),
    "deadline": MessageLookupByLibrary.simpleMessage("Date limite :"),
    "deadlineLabel": m3,
    "deadlineSelected": m4,
    "detailLoadError": MessageLookupByLibrary.simpleMessage(
      "Erreur de chargement du détail",
    ),
    "enterTaskNameError": MessageLookupByLibrary.simpleMessage(
      "Veuillez entrer un nom pour la tâche.",
    ),
    "haveAccount": MessageLookupByLibrary.simpleMessage(
      "Vous avez déjà un compte ?",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Accueil"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("Accueil"),
    "invalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Nom d\'utilisateur ou mot de passe incorrect",
    ),
    "loadingError": MessageLookupByLibrary.simpleMessage(
      "Erreur de chargement",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "loginBtn": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "loginFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la connexion",
    ),
    "logout": MessageLookupByLibrary.simpleMessage("Déconnexion"),
    "logoutError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la déconnexion",
    ),
    "logoutSuccess": MessageLookupByLibrary.simpleMessage(
      "Déconnexion réussie",
    ),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "noAccount": MessageLookupByLibrary.simpleMessage(
      "Vous n\'avez pas de compte?",
    ),
    "noImage": MessageLookupByLibrary.simpleMessage("Aucune image"),
    "noTasksAvailable": MessageLookupByLibrary.simpleMessage(
      "Aucune tâche disponible",
    ),
    "passwordHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre mot de passe",
    ),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "progress": MessageLookupByLibrary.simpleMessage("Avancement :"),
    "progressLabel": MessageLookupByLibrary.simpleMessage("Avancement"),
    "selectDeadlineError": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner une date limite.",
    ),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "Erreur serveur, veuillez réessayer",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("Inscription"),
    "signUpLink": MessageLookupByLibrary.simpleMessage("S\'inscrire"),
    "signupFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de l\'inscription",
    ),
    "taskCreation": MessageLookupByLibrary.simpleMessage("Création de tâche"),
    "taskImage": MessageLookupByLibrary.simpleMessage("Image de la tâche :"),
    "taskNameLabel": MessageLookupByLibrary.simpleMessage("Nom de la tâche"),
    "timeElapsedLabel": MessageLookupByLibrary.simpleMessage("Temps écoulé"),
    "timeElapsedPercentage": MessageLookupByLibrary.simpleMessage(
      "Pourcentage de temps écoulé :",
    ),
    "updateError": MessageLookupByLibrary.simpleMessage(
      "Erreur lors de la mise à jour",
    ),
    "user": MessageLookupByLibrary.simpleMessage("Utilisateur"),
    "usernameHint": MessageLookupByLibrary.simpleMessage(
      "Entrez votre courriel",
    ),
    "usernameLabel": MessageLookupByLibrary.simpleMessage("Nom d\'utilisateur"),
  };
}
