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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Fund TetraConnect`
  String get fundTetraConnect {
    return Intl.message(
      'Fund TetraConnect',
      name: 'fundTetraConnect',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Time Control`
  String get timeControl {
    return Intl.message(
      'Time Control',
      name: 'timeControl',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Re-Authentication`
  String get reAuthentication {
    return Intl.message(
      'Re-Authentication',
      name: 'reAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter display name`
  String get enterDisplayName {
    return Intl.message(
      'Enter display name',
      name: 'enterDisplayName',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Show password`
  String get showPassword {
    return Intl.message(
      'Show password',
      name: 'showPassword',
      desc: '',
      args: [],
    );
  }

  /// `Hide password`
  String get hidePassword {
    return Intl.message(
      'Hide password',
      name: 'hidePassword',
      desc: '',
      args: [],
    );
  }

  /// `Display name must have no profanity`
  String get displayNameNoProfanity {
    return Intl.message(
      'Display name must have no profanity',
      name: 'displayNameNoProfanity',
      desc: '',
      args: [],
    );
  }

  /// `Email must have no profanity`
  String get emailNoProfanity {
    return Intl.message(
      'Email must have no profanity',
      name: 'emailNoProfanity',
      desc: '',
      args: [],
    );
  }

  /// `Password must have no profanity`
  String get passwordNoProfanity {
    return Intl.message(
      'Password must have no profanity',
      name: 'passwordNoProfanity',
      desc: '',
      args: [],
    );
  }

  /// `Emails must be formatted as: abc@example.com`
  String get emailFormat {
    return Intl.message(
      'Emails must be formatted as: abc@example.com',
      name: 'emailFormat',
      desc: '',
      args: [],
    );
  }

  /// `Email must have no whitespaces`
  String get emailNoWhiteSpace {
    return Intl.message(
      'Email must have no whitespaces',
      name: 'emailNoWhiteSpace',
      desc: '',
      args: [],
    );
  }

  /// `Password must have:\n- A special character\n- A capital letter\n- A number\n- A lower case letter`
  String get passwordCharacters {
    return Intl.message(
      'Password must have:\n- A special character\n- A capital letter\n- A number\n- A lower case letter',
      name: 'passwordCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Display name is empty`
  String get displayNameEmpty {
    return Intl.message(
      'Display name is empty',
      name: 'displayNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email is empty`
  String get emailEmpty {
    return Intl.message(
      'Email is empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password empty`
  String get passwordEmpty {
    return Intl.message(
      'Password empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Passwords don't match`
  String get passwordsNotMatching {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwordsNotMatching',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 10 characters long`
  String get passwordLength {
    return Intl.message(
      'Password must be at least 10 characters long',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent to {verificationEmail}. If you have not received the email, then check your spam or junk folders for the email`
  String verificationEmail(Object verificationEmail) {
    return Intl.message(
      'A verification email has been sent to $verificationEmail. If you have not received the email, then check your spam or junk folders for the email',
      name: 'verificationEmail',
      desc: '',
      args: [verificationEmail],
    );
  }

  /// `App version: {version}`
  String appVersion(Object version) {
    return Intl.message(
      'App version: $version',
      name: 'appVersion',
      desc: '',
      args: [version],
    );
  }

  /// `Keep me logged in`
  String get keepLoggedIn {
    return Intl.message(
      'Keep me logged in',
      name: 'keepLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Text Scale Factor`
  String get tsf {
    return Intl.message(
      'Text Scale Factor',
      name: 'tsf',
      desc: '',
      args: [],
    );
  }

  /// `UI Mode`
  String get uiMode {
    return Intl.message(
      'UI Mode',
      name: 'uiMode',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get system {
    return Intl.message(
      'System',
      name: 'system',
      desc: '',
      args: [],
    );
  }

  /// `Re-authentication`
  String get reAuth {
    return Intl.message(
      'Re-authentication',
      name: 'reAuth',
      desc: '',
      args: [],
    );
  }

  /// `You must re-authenticate before modifying your profile to ensure your account is secure`
  String get reAuthDesc {
    return Intl.message(
      'You must re-authenticate before modifying your profile to ensure your account is secure',
      name: 'reAuthDesc',
      desc: '',
      args: [],
    );
  }

  /// `Re-authenticate`
  String get reAuthVerb {
    return Intl.message(
      'Re-authenticate',
      name: 'reAuthVerb',
      desc: '',
      args: [],
    );
  }

  /// `Blank`
  String get blank {
    return Intl.message(
      'Blank',
      name: 'blank',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Initials`
  String get initials {
    return Intl.message(
      'Initials',
      name: 'initials',
      desc: '',
      args: [],
    );
  }

  /// `No change`
  String get noChange {
    return Intl.message(
      'No change',
      name: 'noChange',
      desc: '',
      args: [],
    );
  }

  /// `Choose initials colour`
  String get chooseInitialsColour {
    return Intl.message(
      'Choose initials colour',
      name: 'chooseInitialsColour',
      desc: '',
      args: [],
    );
  }

  /// `Randomise`
  String get randomise {
    return Intl.message(
      'Randomise',
      name: 'randomise',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Oh snap! There's been an error 😢.`
  String get error {
    return Intl.message(
      'Oh snap! There\'s been an error 😢.',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Guide`
  String get guide {
    return Intl.message(
      'Guide',
      name: 'guide',
      desc: '',
      args: [],
    );
  }

  /// `Statistics`
  String get statistics {
    return Intl.message(
      'Statistics',
      name: 'statistics',
      desc: '',
      args: [],
    );
  }

  /// `Game Log`
  String get gameLog {
    return Intl.message(
      'Game Log',
      name: 'gameLog',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Manage your account details`
  String get accountDesc {
    return Intl.message(
      'Manage your account details',
      name: 'accountDesc',
      desc: '',
      args: [],
    );
  }

  /// `View all of your games`
  String get gameLogDesc {
    return Intl.message(
      'View all of your games',
      name: 'gameLogDesc',
      desc: '',
      args: [],
    );
  }

  /// `View your game statistics`
  String get statisticsDesc {
    return Intl.message(
      'View your game statistics',
      name: 'statisticsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Continue to home`
  String get continueToHome {
    return Intl.message(
      'Continue to home',
      name: 'continueToHome',
      desc: '',
      args: [],
    );
  }

  /// `Your ID: {id}`
  String yourID(Object id) {
    return Intl.message(
      'Your ID: $id',
      name: 'yourID',
      desc: '',
      args: [id],
    );
  }

  /// `Rating: {rating}`
  String rating(Object rating) {
    return Intl.message(
      'Rating: $rating',
      name: 'rating',
      desc: '',
      args: [rating],
    );
  }

  /// `Results:`
  String get results {
    return Intl.message(
      'Results:',
      name: 'results',
      desc: '',
      args: [],
    );
  }

  /// `Save changes`
  String get saveChanges {
    return Intl.message(
      'Save changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `1st`
  String get first {
    return Intl.message(
      '1st',
      name: 'first',
      desc: '',
      args: [],
    );
  }

  /// `2nd`
  String get second {
    return Intl.message(
      '2nd',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `3rd`
  String get third {
    return Intl.message(
      '3rd',
      name: 'third',
      desc: '',
      args: [],
    );
  }

  /// `4th`
  String get fourth {
    return Intl.message(
      '4th',
      name: 'fourth',
      desc: '',
      args: [],
    );
  }

  /// `Number of times you have finished {place}`
  String placeTooltip(Object place) {
    return Intl.message(
      'Number of times you have finished $place',
      name: 'placeTooltip',
      desc: '',
      args: [place],
    );
  }

  /// `{day}/{month}/{year}`
  String date(Object day, Object month, Object year) {
    return Intl.message(
      '$day/$month/$year',
      name: 'date',
      desc: '',
      args: [day, month, year],
    );
  }

  /// `Go forward`
  String get forward {
    return Intl.message(
      'Go forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `Go backward`
  String get backward {
    return Intl.message(
      'Go backward',
      name: 'backward',
      desc: '',
      args: [],
    );
  }

  /// `Send friend request`
  String get sendFriendRequest {
    return Intl.message(
      'Send friend request',
      name: 'sendFriendRequest',
      desc: '',
      args: [],
    );
  }

  /// `Pending friend requests`
  String get pendingFriendRequests {
    return Intl.message(
      'Pending friend requests',
      name: 'pendingFriendRequests',
      desc: '',
      args: [],
    );
  }

  /// `Incoming friend requests`
  String get incomingFriendRequests {
    return Intl.message(
      'Incoming friend requests',
      name: 'incomingFriendRequests',
      desc: '',
      args: [],
    );
  }

  /// `Chat with friends`
  String get chatWithFriends {
    return Intl.message(
      'Chat with friends',
      name: 'chatWithFriends',
      desc: '',
      args: [],
    );
  }

  /// `Remove friends`
  String get removeFriends {
    return Intl.message(
      'Remove friends',
      name: 'removeFriends',
      desc: '',
      args: [],
    );
  }

  /// `Display name`
  String get displayName {
    return Intl.message(
      'Display name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `User ID`
  String get uid {
    return Intl.message(
      'User ID',
      name: 'uid',
      desc: '',
      args: [],
    );
  }

  /// `Search for user`
  String get searchForUser {
    return Intl.message(
      'Search for user',
      name: 'searchForUser',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get removeFriend {
    return Intl.message(
      'Remove friend',
      name: 'removeFriend',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
