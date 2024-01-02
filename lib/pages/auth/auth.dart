import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tetraconnect/pages/auth/verify.dart';
import 'package:tetraconnect/pages/home/home.dart';

import '../../util/api.dart';
import './login.dart';
import './signup.dart';
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    if (provider(context).user != null) {
      Future.delayed(
        Duration.zero,
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => auth.currentUser!.emailVerified ? const HomePage() : const VerifyPage(),
            ),
          );
        },
      );
    }
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
          child: Column(
            children: [
              logo(
                radius: 90.0,
                padding: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "TetraConnect",
                  textScaler: TextScaler.linear(provider(context).tsf),
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    textScaler: TextScaler.linear(provider(context).tsf),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.5,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.grey[900],
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
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
                      fontSize: 17.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
