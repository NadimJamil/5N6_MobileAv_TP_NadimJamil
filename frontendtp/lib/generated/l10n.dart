// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Todo Application`
  String get appTitle {
    return Intl.message(
      'Todo Application',
      name: 'appTitle',
      desc: 'Application title',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Enter your username`
  String get usernameHint {
    return Intl.message(
      'Enter your username',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get passwordHint {
    return Intl.message(
      'Enter your password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmPasswordHint {
    return Intl.message(
      'Confirm your password',
      name: 'confirmPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueBtn {
    return Intl.message('Continue', name: 'continueBtn', desc: '', args: []);
  }

  /// `Already have an account?`
  String get haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get login {
    return Intl.message('Log In', name: 'login', desc: '', args: []);
  }

  /// `Sign up failed`
  String get signupFailed {
    return Intl.message(
      'Sign up failed',
      name: 'signupFailed',
      desc: 'Message displayed when sign up fails',
      args: [],
    );
  }

  /// `Login`
  String get connectionTitle {
    return Intl.message(
      'Login',
      name: 'connectionTitle',
      desc: 'Login page title',
      args: [],
    );
  }

  /// `Username`
  String get usernameLabel {
    return Intl.message(
      'Username',
      name: 'usernameLabel',
      desc: 'Label for username field',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: 'Label for password field',
      args: [],
    );
  }

  /// `Log In`
  String get loginBtn {
    return Intl.message(
      'Log In',
      name: 'loginBtn',
      desc: 'Login button text',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get noAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'noAccount',
      desc: 'Message for users without an account',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUpLink {
    return Intl.message(
      'Sign Up',
      name: 'signUpLink',
      desc: 'Link to sign up page',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: 'Message displayed when login fails',
      args: [],
    );
  }

  /// `Connection error: {error}`
  String connectionError(String error) {
    return Intl.message(
      'Connection error: $error',
      name: 'connectionError',
      desc: 'Connection error message with details',
      args: [error],
    );
  }

  /// `Invalid username or password`
  String get invalidCredentials {
    return Intl.message(
      'Invalid username or password',
      name: 'invalidCredentials',
      desc: 'Message for invalid credentials',
      args: [],
    );
  }

  /// `Server error, please try again`
  String get serverError {
    return Intl.message(
      'Server error, please try again',
      name: 'serverError',
      desc: 'Server error message',
      args: [],
    );
  }

  /// `Consultation`
  String get consultationTitle {
    return Intl.message(
      'Consultation',
      name: 'consultationTitle',
      desc: 'Consultation page title',
      args: [],
    );
  }

  /// `Progress:`
  String get progress {
    return Intl.message(
      'Progress:',
      name: 'progress',
      desc: 'Label for task progress',
      args: [],
    );
  }

  /// `Deadline:`
  String get deadline {
    return Intl.message(
      'Deadline:',
      name: 'deadline',
      desc: 'Label for deadline',
      args: [],
    );
  }

  /// `Time elapsed percentage:`
  String get timeElapsedPercentage {
    return Intl.message(
      'Time elapsed percentage:',
      name: 'timeElapsedPercentage',
      desc: 'Label for time elapsed percentage',
      args: [],
    );
  }

  /// `Change progress: `
  String get changeProgress {
    return Intl.message(
      'Change progress: ',
      name: 'changeProgress',
      desc: 'Label for changing progress',
      args: [],
    );
  }

  /// `Add image: `
  String get addImage {
    return Intl.message(
      'Add image: ',
      name: 'addImage',
      desc: 'Label for adding an image',
      args: [],
    );
  }

  /// `Choose an image`
  String get chooseImage {
    return Intl.message(
      'Choose an image',
      name: 'chooseImage',
      desc: 'Button text for choosing an image',
      args: [],
    );
  }

  /// `Task image:`
  String get taskImage {
    return Intl.message(
      'Task image:',
      name: 'taskImage',
      desc: 'Label for task image',
      args: [],
    );
  }

  /// `No image`
  String get noImage {
    return Intl.message(
      'No image',
      name: 'noImage',
      desc: 'Message when no image is available',
      args: [],
    );
  }

  /// `Loading error`
  String get loadingError {
    return Intl.message(
      'Loading error',
      name: 'loadingError',
      desc: 'Image loading error message',
      args: [],
    );
  }

  /// `Update error`
  String get updateError {
    return Intl.message(
      'Update error',
      name: 'updateError',
      desc: 'Update error message',
      args: [],
    );
  }

  /// `Detail loading error`
  String get detailLoadError {
    return Intl.message(
      'Detail loading error',
      name: 'detailLoadError',
      desc: 'Detail loading error message',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: 'Drawer menu title',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home menu option',
      args: [],
    );
  }

  /// `Task Creation`
  String get taskCreation {
    return Intl.message(
      'Task Creation',
      name: 'taskCreation',
      desc: 'Task creation menu option',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: 'Logout menu option',
      args: [],
    );
  }

  /// `Home`
  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: 'Home page title',
      args: [],
    );
  }

  /// `No tasks available`
  String get noTasksAvailable {
    return Intl.message(
      'No tasks available',
      name: 'noTasksAvailable',
      desc: 'Message when no tasks are available',
      args: [],
    );
  }

  /// `Error during logout`
  String get logoutError {
    return Intl.message(
      'Error during logout',
      name: 'logoutError',
      desc: 'Error message during logout',
      args: [],
    );
  }

  /// `Connection error: {error}`
  String connectionErrorWithDetails(String error) {
    return Intl.message(
      'Connection error: $error',
      name: 'connectionErrorWithDetails',
      desc: 'Connection error message with details',
      args: [error],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: 'Default user label',
      args: [],
    );
  }

  /// `Task Creation`
  String get creationTitle {
    return Intl.message(
      'Task Creation',
      name: 'creationTitle',
      desc: 'Task creation page title',
      args: [],
    );
  }

  /// `Task name`
  String get taskNameLabel {
    return Intl.message(
      'Task name',
      name: 'taskNameLabel',
      desc: 'Label for task name',
      args: [],
    );
  }

  /// `Choose a deadline`
  String get chooseDeadline {
    return Intl.message(
      'Choose a deadline',
      name: 'chooseDeadline',
      desc: 'Text for choosing a deadline',
      args: [],
    );
  }

  /// `Deadline: {date}`
  String deadlineSelected(String date) {
    return Intl.message(
      'Deadline: $date',
      name: 'deadlineSelected',
      desc: 'Text when a deadline is selected',
      args: [date],
    );
  }

  /// `Add task`
  String get addTask {
    return Intl.message(
      'Add task',
      name: 'addTask',
      desc: 'Add task button text',
      args: [],
    );
  }

  /// `Please select a deadline.`
  String get selectDeadlineError {
    return Intl.message(
      'Please select a deadline.',
      name: 'selectDeadlineError',
      desc: 'Error message if no date is selected',
      args: [],
    );
  }

  /// `Please enter a task name.`
  String get enterTaskNameError {
    return Intl.message(
      'Please enter a task name.',
      name: 'enterTaskNameError',
      desc: 'Error message if no name is entered',
      args: [],
    );
  }

  /// `Creation error: {error}`
  String creationError(String error) {
    return Intl.message(
      'Creation error: $error',
      name: 'creationError',
      desc: 'Error message during creation',
      args: [error],
    );
  }

  /// `Progress`
  String get progressLabel {
    return Intl.message(
      'Progress',
      name: 'progressLabel',
      desc: 'Label for progress in the card',
      args: [],
    );
  }

  /// `Time elapsed`
  String get timeElapsedLabel {
    return Intl.message(
      'Time elapsed',
      name: 'timeElapsedLabel',
      desc: 'Label for time elapsed in the card',
      args: [],
    );
  }

  /// `Deadline: {date}`
  String deadlineLabel(String date) {
    return Intl.message(
      'Deadline: $date',
      name: 'deadlineLabel',
      desc: 'Label for deadline in the card',
      args: [date],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
