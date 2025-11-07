// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(error) => "Connection error: ${error}";

  static String m1(error) => "Connection error: ${error}";

  static String m2(error) => "Creation error: ${error}";

  static String m3(date) => "Deadline: ${date}";

  static String m4(date) => "Deadline: ${date}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "addImage": MessageLookupByLibrary.simpleMessage("Add image: "),
    "addTask": MessageLookupByLibrary.simpleMessage("Add task"),
    "appTitle": MessageLookupByLibrary.simpleMessage("Todo Application"),
    "changeProgress": MessageLookupByLibrary.simpleMessage("Change progress: "),
    "chooseDeadline": MessageLookupByLibrary.simpleMessage("Choose a deadline"),
    "chooseImage": MessageLookupByLibrary.simpleMessage("Choose an image"),
    "confirmPasswordHint": MessageLookupByLibrary.simpleMessage(
      "Confirm your password",
    ),
    "connectionError": m0,
    "connectionErrorWithDetails": m1,
    "connectionTitle": MessageLookupByLibrary.simpleMessage("Login"),
    "consultationTitle": MessageLookupByLibrary.simpleMessage("Consultation"),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continue"),
    "creationError": m2,
    "creationTitle": MessageLookupByLibrary.simpleMessage("Task Creation"),
    "deadline": MessageLookupByLibrary.simpleMessage("Deadline:"),
    "deadlineLabel": m3,
    "deadlineSelected": m4,
    "detailLoadError": MessageLookupByLibrary.simpleMessage(
      "Detail loading error",
    ),
    "enterTaskNameError": MessageLookupByLibrary.simpleMessage(
      "Please enter a task name.",
    ),
    "haveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "home": MessageLookupByLibrary.simpleMessage("Home"),
    "homeTitle": MessageLookupByLibrary.simpleMessage("Home"),
    "invalidCredentials": MessageLookupByLibrary.simpleMessage(
      "Invalid username or password",
    ),
    "loadingError": MessageLookupByLibrary.simpleMessage("Loading error"),
    "login": MessageLookupByLibrary.simpleMessage("Log In"),
    "loginBtn": MessageLookupByLibrary.simpleMessage("Log In"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Login failed"),
    "logout": MessageLookupByLibrary.simpleMessage("Logout"),
    "logoutError": MessageLookupByLibrary.simpleMessage("Error during logout"),
    "menu": MessageLookupByLibrary.simpleMessage("Menu"),
    "noAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "noImage": MessageLookupByLibrary.simpleMessage("No image"),
    "noTasksAvailable": MessageLookupByLibrary.simpleMessage(
      "No tasks available",
    ),
    "passwordHint": MessageLookupByLibrary.simpleMessage("Enter your password"),
    "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
    "progress": MessageLookupByLibrary.simpleMessage("Progress:"),
    "progressLabel": MessageLookupByLibrary.simpleMessage("Progress"),
    "selectDeadlineError": MessageLookupByLibrary.simpleMessage(
      "Please select a deadline.",
    ),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "Server error, please try again",
    ),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signUpLink": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "signupFailed": MessageLookupByLibrary.simpleMessage("Sign up failed"),
    "taskCreation": MessageLookupByLibrary.simpleMessage("Task Creation"),
    "taskImage": MessageLookupByLibrary.simpleMessage("Task image:"),
    "taskNameLabel": MessageLookupByLibrary.simpleMessage("Task name"),
    "timeElapsedLabel": MessageLookupByLibrary.simpleMessage("Time elapsed"),
    "timeElapsedPercentage": MessageLookupByLibrary.simpleMessage(
      "Time elapsed percentage:",
    ),
    "updateError": MessageLookupByLibrary.simpleMessage("Update error"),
    "user": MessageLookupByLibrary.simpleMessage("User"),
    "usernameHint": MessageLookupByLibrary.simpleMessage("Enter your username"),
    "usernameLabel": MessageLookupByLibrary.simpleMessage("Username"),
  };
}
