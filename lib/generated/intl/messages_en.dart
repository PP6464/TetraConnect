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

  static String m0(version) => "App version: ${version}";

  static String m1(verificationEmail) =>
      "A verification email has been sent to ${verificationEmail}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appVersion": m0,
        "blank": MessageLookupByLibrary.simpleMessage("Blank"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "chooseInitialsColour":
            MessageLookupByLibrary.simpleMessage("Choose initials colour"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "displayNameEmpty":
            MessageLookupByLibrary.simpleMessage("Display name is empty"),
        "displayNameNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Display name must have no profanity"),
        "emailEmpty": MessageLookupByLibrary.simpleMessage("Email is empty"),
        "emailFormat": MessageLookupByLibrary.simpleMessage(
            "Emails must be formatted as: abc@example.com"),
        "emailNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Email must have no profanity"),
        "enterDisplayName":
            MessageLookupByLibrary.simpleMessage("Enter display name"),
        "enterEmail": MessageLookupByLibrary.simpleMessage("Enter email"),
        "enterPassword": MessageLookupByLibrary.simpleMessage("Enter password"),
        "error": MessageLookupByLibrary.simpleMessage(
            "Oh snap! There\'s been an error 😢."),
        "friends": MessageLookupByLibrary.simpleMessage("Friends"),
        "fundTetraConnect":
            MessageLookupByLibrary.simpleMessage("Fund TetraConnect"),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "guide": MessageLookupByLibrary.simpleMessage("Guide"),
        "hidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "initials": MessageLookupByLibrary.simpleMessage("Initials"),
        "keepLoggedIn":
            MessageLookupByLibrary.simpleMessage("Keep me logged in"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "noChange": MessageLookupByLibrary.simpleMessage("No change"),
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "passwordCharacters": MessageLookupByLibrary.simpleMessage(
            "Password must have:\n- A special character\n- A capital letter\n- A number\n- A lower case letter"),
        "passwordEmpty": MessageLookupByLibrary.simpleMessage("Password empty"),
        "passwordNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Password must have no profanity"),
        "passwordsNotMatching":
            MessageLookupByLibrary.simpleMessage("Passwords don\'t match"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "randomise": MessageLookupByLibrary.simpleMessage("Randomise"),
        "reAuth": MessageLookupByLibrary.simpleMessage("Re-authentication"),
        "reAuthDesc": MessageLookupByLibrary.simpleMessage(
            "You must re-authenticate before modifying your profile to ensure your account is secure"),
        "reAuthentication":
            MessageLookupByLibrary.simpleMessage("Re-Authentication"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "timeControl": MessageLookupByLibrary.simpleMessage("Time Control"),
        "tsf": MessageLookupByLibrary.simpleMessage("Text Scale Factor"),
        "uiMode": MessageLookupByLibrary.simpleMessage("UI Mode"),
        "verificationEmail": m1
      };
}