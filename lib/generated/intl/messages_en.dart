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

  static String m1(day, month, year) => "${day}/${month}/${year}";

  static String m2(name) => "${name} has sent a friend request";

  static String m3(n) => "Player ${n}";

  static String m4(n) => "${n}/4 players found";

  static String m5(place) => "Number of times you have finished ${place}";

  static String m6(rating) => "Rating: ${rating}";

  static String m7(hours, minutes, day, month, year) =>
      "${hours}:${minutes} ${day}/${month}/${year}";

  static String m8(verificationEmail) =>
      "A verification email has been sent to ${verificationEmail}. If you have not received the email, then check your spam or junk folders for the email";

  static String m9(id) => "Your ID: ${id}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("Accept"),
        "account": MessageLookupByLibrary.simpleMessage("Account"),
        "accountDesc":
            MessageLookupByLibrary.simpleMessage("Manage your account details"),
        "aimOfGame": MessageLookupByLibrary.simpleMessage("Aim of the game"),
        "appVersion": m0,
        "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "areYouSureDelete": MessageLookupByLibrary.simpleMessage(
            "Are you sure you would like to delete your account?"),
        "backward": MessageLookupByLibrary.simpleMessage("Go backward"),
        "blank": MessageLookupByLibrary.simpleMessage("Blank"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "chatWithFriends":
            MessageLookupByLibrary.simpleMessage("Chat with friends"),
        "chooseInitialsColour":
            MessageLookupByLibrary.simpleMessage("Choose initials colour"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm password"),
        "continueToHome":
            MessageLookupByLibrary.simpleMessage("Continue to home"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "date": m1,
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
        "deleteAccountWarning":
            MessageLookupByLibrary.simpleMessage("Delete account warning"),
        "deleteFriendRequest":
            MessageLookupByLibrary.simpleMessage("Delete friend request"),
        "displayName": MessageLookupByLibrary.simpleMessage("Display name"),
        "displayNameEmpty":
            MessageLookupByLibrary.simpleMessage("Display name is empty"),
        "displayNameNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Display name must have no profanity"),
        "emailEmpty": MessageLookupByLibrary.simpleMessage("Email is empty"),
        "emailFormat": MessageLookupByLibrary.simpleMessage(
            "Emails must be formatted as: abc@example.com"),
        "emailNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Email must have no profanity"),
        "emailNoWhiteSpace": MessageLookupByLibrary.simpleMessage(
            "Email must have no whitespaces"),
        "enterDisplayName":
            MessageLookupByLibrary.simpleMessage("Enter display name"),
        "enterEmail": MessageLookupByLibrary.simpleMessage("Enter email"),
        "enterPassword": MessageLookupByLibrary.simpleMessage("Enter password"),
        "error": MessageLookupByLibrary.simpleMessage(
            "Oh snap! There\'s been an error 😢."),
        "first": MessageLookupByLibrary.simpleMessage("1st"),
        "forward": MessageLookupByLibrary.simpleMessage("Go forward"),
        "fourth": MessageLookupByLibrary.simpleMessage("4th"),
        "friends": MessageLookupByLibrary.simpleMessage("Friends"),
        "fundMessage": MessageLookupByLibrary.simpleMessage(
            "You are being redirected to the buymeacoffee page for the developers (If it doesn\'t work please try https://buymeacoffee.com/pp16). Thank you for choosing to support us."),
        "fundTetraConnect":
            MessageLookupByLibrary.simpleMessage("Fund TetraConnect"),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "gameIntroP1": MessageLookupByLibrary.simpleMessage(
            "The aim of the game is to form a four in a row. You play against three other players, and whoever makes four in a row first wins.\n\n The game is still played until either the grid is filled or until first, second and third have all been decided (at which point the remaining player is fourth).\n\nGravity is present in the game, as can be seen in the gif below:"),
        "gameIntroP2": MessageLookupByLibrary.simpleMessage(
            "As can be seen above, the pieces go to the lowest available space in their column. Now that you understand the rules, enjoy playing the game! 😀👍"),
        "gameLog": MessageLookupByLibrary.simpleMessage("Game Log"),
        "gameLogDesc":
            MessageLookupByLibrary.simpleMessage("View all of your games"),
        "guide": MessageLookupByLibrary.simpleMessage("Guide"),
        "hidePassword": MessageLookupByLibrary.simpleMessage("Hide password"),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "incomingFriendRequests":
            MessageLookupByLibrary.simpleMessage("Incoming friend requests"),
        "initials": MessageLookupByLibrary.simpleMessage("Initials"),
        "keepLoggedIn":
            MessageLookupByLibrary.simpleMessage("Keep me logged in"),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "messageNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Message must not contain profanity"),
        "messageRequired":
            MessageLookupByLibrary.simpleMessage("Message required"),
        "noChange": MessageLookupByLibrary.simpleMessage("No change"),
        "noChatFriends":
            MessageLookupByLibrary.simpleMessage("No friends to chat with"),
        "noIncomingRequests":
            MessageLookupByLibrary.simpleMessage("No incoming friend requests"),
        "noPendingRequests":
            MessageLookupByLibrary.simpleMessage("No pending friend requests"),
        "noRemoveFriends":
            MessageLookupByLibrary.simpleMessage("No friends to remove"),
        "notificationSentFriendRequestTitle": m2,
        "nthPlayer": m3,
        "numberOfPlayers": m4,
        "ok": MessageLookupByLibrary.simpleMessage("Ok"),
        "onOtherDevice": MessageLookupByLibrary.simpleMessage(
            "User with this account is matchmaking on another device"),
        "online": MessageLookupByLibrary.simpleMessage("Online"),
        "passPlay": MessageLookupByLibrary.simpleMessage("Pass and play"),
        "passwordCharacters": MessageLookupByLibrary.simpleMessage(
            "Password must have:\n- A special character\n- A capital letter\n- A number\n- A lower case letter"),
        "passwordEmpty": MessageLookupByLibrary.simpleMessage("Password empty"),
        "passwordLength": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 10 characters long"),
        "passwordNoProfanity": MessageLookupByLibrary.simpleMessage(
            "Password must have no profanity"),
        "passwordsNotMatching":
            MessageLookupByLibrary.simpleMessage("Passwords don\'t match"),
        "pendingFriendRequests":
            MessageLookupByLibrary.simpleMessage("Pending friend requests"),
        "placePiece":
            MessageLookupByLibrary.simpleMessage("Place piece in this column"),
        "placeTooltip": m5,
        "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy policy"),
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "randomise": MessageLookupByLibrary.simpleMessage("Randomise"),
        "rating": m6,
        "reAuth": MessageLookupByLibrary.simpleMessage("Re-authentication"),
        "reAuthDesc": MessageLookupByLibrary.simpleMessage(
            "You must re-authenticate before modifying your profile to ensure your account is secure"),
        "reAuthVerb": MessageLookupByLibrary.simpleMessage("Re-authenticate"),
        "reAuthentication":
            MessageLookupByLibrary.simpleMessage("Re-Authentication"),
        "reject": MessageLookupByLibrary.simpleMessage("Reject"),
        "removeFriend": MessageLookupByLibrary.simpleMessage("Remove friend"),
        "removeFriends": MessageLookupByLibrary.simpleMessage("Remove friends"),
        "results": MessageLookupByLibrary.simpleMessage("Results:"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save changes"),
        "searchForUser":
            MessageLookupByLibrary.simpleMessage("Search for user"),
        "searchingForPlayers":
            MessageLookupByLibrary.simpleMessage("Searching for players ..."),
        "second": MessageLookupByLibrary.simpleMessage("2nd"),
        "sendFriendRequest":
            MessageLookupByLibrary.simpleMessage("Send friend request"),
        "sendMessage": MessageLookupByLibrary.simpleMessage("Send message"),
        "sending": MessageLookupByLibrary.simpleMessage("Sending ..."),
        "sent": MessageLookupByLibrary.simpleMessage("Sent"),
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "showPassword": MessageLookupByLibrary.simpleMessage("Show password"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "startConversation":
            MessageLookupByLibrary.simpleMessage("Start the conversation!"),
        "startGame": MessageLookupByLibrary.simpleMessage("Start a game!"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistics"),
        "statisticsDesc":
            MessageLookupByLibrary.simpleMessage("View your game statistics"),
        "system": MessageLookupByLibrary.simpleMessage("System"),
        "third": MessageLookupByLibrary.simpleMessage("3rd"),
        "timeControl": MessageLookupByLibrary.simpleMessage("Time Control"),
        "timestamp": m7,
        "tsAndCs": MessageLookupByLibrary.simpleMessage(
            "To ensure that other users can see their games, your profile picture and display name will be kept. If you would like to hide this information, just change your display name to a space bar and your profile picture to a blank person one"),
        "tsf": MessageLookupByLibrary.simpleMessage("Text Scale Factor"),
        "uiMode": MessageLookupByLibrary.simpleMessage("UI Mode"),
        "uid": MessageLookupByLibrary.simpleMessage("User ID"),
        "verificationEmail": m8,
        "yourID": m9
      };
}
