// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/pages/play/pass.play.dart';

import '../pages/guide/guide.dart';
import '../pages/home/home.dart';
import '../pages/auth/auth.dart';
import '../pages/fund.tetraconnect/fund.tetraconnect.dart';
import '../pages/friends/friends.dart';
import '../pages/profile/profile.dart';
import '../pages/settings/settings.dart';

enum route {
  fundTetraConnect,
  friends,
  guide,
  home,
  profile,
  passPlay,
  settings,
  logout,
}

extension RouteExt on route {
  String name(BuildContext context) {
    switch (this) {
      case route.fundTetraConnect:
        return AppLocalizations.of(context)!.fundTetraConnect;
      case route.home:
        return AppLocalizations.of(context)!.home;
      case route.friends:
        return AppLocalizations.of(context)!.friends;
      case route.profile:
        return AppLocalizations.of(context)!.profile;
      case route.passPlay:
        return AppLocalizations.of(context)!.passPlay;
      case route.settings:
        return AppLocalizations.of(context)!.settings;
      case route.logout:
        return AppLocalizations.of(context)!.logout;
      case route.guide:
        return AppLocalizations.of(context)!.guide;
    }
  }

  Widget get widget {
    switch (this) {
      case route.fundTetraConnect:
        return const FundTetraConnectPage();
      case route.home:
        return const HomePage();
      case route.friends:
        return const FriendsPage();
      case route.profile:
        return const ProfilePage();
      case route.passPlay:
        return const PassPlayPage();
      case route.settings:
        return const SettingsPage();
      case route.logout:
        return const AuthPage();
      case route.guide:
        return const GuidePage();
    }
  }

  String get value {
    switch (this) {
      case route.fundTetraConnect:
        return "fundTetraConnect";
      case route.home:
        return "home";
      case route.friends:
        return "friends";
      case route.profile:
        return "profile";
      case route.passPlay:
        return "passPlay";
      case route.settings:
        return "settings";
      case route.logout:
        return "logout";
      case route.guide:
        return "guide";
    }
  }
}
