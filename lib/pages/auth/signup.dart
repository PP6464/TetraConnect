// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/regex.dart';
import '../../ui/theme.dart';
import './verify.dart';
import '../../util/api.dart';
import '../../util/models.dart' as models;
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool keepLoggedIn = false;

  @override
  void dispose() {
    super.dispose();
    for (var e in <TextEditingController>[
      displayNameController,
      emailController,
      passwordController,
      confirmPasswordController,
    ]) {
      e.dispose();
    }
    obscurePassword = true;
    obscureConfirmPassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Row(
          children: [
            Text(
              "TetraConnect",
              textScaler: TextScaler.linear(provider(context).tsf),
            ),
            const Spacer(),
            logo(),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: min(500.0, MediaQuery.of(context).size.width),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    logo(
                      radius: 90.0,
                      padding: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.signup,
                        textScaler: TextScaler.linear(provider(context).tsf),
                        style: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: displayNameController,
                      maxLength: 20,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) return AppLocalizations.of(context)!.displayNameEmpty;
                        if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.displayNameNoProfanity;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                        label: Text(
                          AppLocalizations.of(context)!.enterDisplayName,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: emailController,
                      validator: (String? value) {
                        if (value == null || value == "") return AppLocalizations.of(context)!.emailEmpty;
                        if (whitespaces.hasMatch(value)) return AppLocalizations.of(context)!.emailNoWhiteSpace;
                        if (!value.contains("@")) return AppLocalizations.of(context)!.emailFormat;
                        if (!value.split("@")[1].contains(".")) return AppLocalizations.of(context)!.emailFormat;
                        if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.emailNoProfanity;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                        label: Text(
                          AppLocalizations.of(context)!.enterEmail,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      validator: (String? value) {
                        if (value == null || value == "") return AppLocalizations.of(context)!.passwordEmpty;
                        if (value.length < 10) return AppLocalizations.of(context)!.passwordLength;
                        if (!password.hasMatch(value)) return AppLocalizations.of(context)!.passwordCharacters;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: obscurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          tooltip: obscurePassword ? AppLocalizations.of(context)!.showPassword : AppLocalizations.of(context)!.hidePassword,
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.enterPassword,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      validator: (String? value) {
                        if (value != null && value != passwordController.text) return AppLocalizations.of(context)!.passwordsNotMatching;
                        return null;
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: obscureConfirmPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                          tooltip: obscureConfirmPassword ? AppLocalizations.of(context)!.showPassword : AppLocalizations.of(context)!.hidePassword,
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        label: Text(
                          AppLocalizations.of(context)!.confirmPassword,
                          textScaler: TextScaler.linear(provider(context).tsf),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Theme(
                            data: checkBoxTheme(context),
                            child: Checkbox(
                              value: keepLoggedIn,
                              onChanged: (bool? value) {
                                setState(() {
                                  keepLoggedIn = value ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            AppLocalizations.of(context)!.keepLoggedIn,
                            textScaler: TextScaler.linear(provider(context).tsf),
                            style: const TextStyle(
                              fontSize: 17.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () async {
                        if (!key.currentState!.validate()) return;
                        try {
                          UserCredential credential = await auth.createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          credential.user!.updateDisplayName(displayNameController.text);
                          credential.user!.updatePhotoURL(blankPicUrl);
                          firestore.doc("users/${credential.user!.uid}").set({
                            "displayName": displayNameController.text,
                            "email": emailController.text,
                            "photoUrl": blankPicUrl,
                            "rating": 0,
                          });
                          (await SharedPreferences.getInstance()).setBool("keepLoggedIn", keepLoggedIn);
                          (await SharedPreferences.getInstance()).setString("uid", credential.user!.uid);
                          await provider(context).updateUser(await models.User.fromUID(credential.user!.uid));
                        } on FirebaseException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message!),
                            ),
                          );
                        }
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const VerifyPage(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          AppLocalizations.of(context)!.signup,
                          textScaler: TextScaler.linear(provider(context).tsf),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 17.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
