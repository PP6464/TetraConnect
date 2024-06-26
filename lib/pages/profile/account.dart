// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:random_color/random_color.dart';
import 'package:tetraconnect/pages/auth/login.dart';

import '../../ui/theme.dart';
import '../../util/api.dart';
import '../../util/constants.dart';
import '../../util/regex.dart';
import '../../provider/app.settings.dart';
import '../../ui/elements.dart';
import '../../util/route.dart';

enum PicSrc {
  blank,
  camera,
  gallery,
  initials,
  noChange,
}

extension PicSrcExt on PicSrc {
  String string(BuildContext context) {
    switch (this) {
      case PicSrc.blank:
        return AppLocalizations.of(context)!.blank;
      case PicSrc.camera:
        return AppLocalizations.of(context)!.camera;
      case PicSrc.gallery:
        return AppLocalizations.of(context)!.gallery;
      case PicSrc.initials:
        return AppLocalizations.of(context)!.initials;
      case PicSrc.noChange:
        return AppLocalizations.of(context)!.noChange;
    }
  }

  String type() {
    switch (this) {
      case PicSrc.camera:
        return 'file';
      case PicSrc.gallery:
        return 'file';
      case PicSrc.initials:
        return 'url';
      case PicSrc.blank:
        return 'url';
      case PicSrc.noChange:
        return 'url';
    }
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Color initialsColour = Colors.white;
  String picLocation = auth.currentUser!.photoURL!;
  String picMimeType = "image/png";
  Uint8List? imgBytes;
  bool isReAuth = false;
  bool reAuthObscurePassword = true;
  bool profileObscurePassword = true;
  bool loading = false;
  PicSrc picSrc = PicSrc.noChange;
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  TextEditingController reAuthEmail = TextEditingController();
  TextEditingController reAuthPassword = TextEditingController();
  TextEditingController profileDisplayName = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profilePassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    reAuthEmail.dispose();
    reAuthPassword.dispose();
    profileDisplayName.dispose();
    profileEmail.dispose();
    profilePassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: normalAppBar(context, route.profile),
      body: isReAuth
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: min(500.0, MediaQuery.of(context).size.width),
                        ),
                        child: Center(
                          child: Form(
                            key: profileFormKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: picSrc.type() == 'file'
                                      ? !kIsWeb
                                          ? CircleAvatar(
                                              radius: 90.0,
                                              backgroundImage: FileImage(
                                                File(picLocation),
                                              ),
                                            )
                                          : CircleAvatar(
                                              radius: 90.0,
                                              backgroundImage: MemoryImage(imgBytes!),
                                            )
                                      : CircleAvatar(
                                          radius: 90.0,
                                          backgroundImage: NetworkImage(picLocation),
                                        ),
                                ),
                                DropdownButton(
                                  onChanged: (PicSrc? src) async {
                                    if (src == null) return;
                                    switch (src) {
                                      case PicSrc.noChange:
                                        setState(() {
                                          picLocation = auth.currentUser!.photoURL!;
                                          picSrc = src;
                                        });
                                        break;
                                      case PicSrc.initials:
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!.chooseInitialsColour,
                                              textScaler: TextScaler.linear(provider(context).tsf),
                                            ),
                                            content: BlockPicker(
                                              pickerColor: initialsColour,
                                              onColorChanged: (Color newColour) {
                                                setState(() {
                                                  initialsColour = newColour;
                                                });
                                              },
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    initialsColour = RandomColor().randomColor();
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.randomise,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.ok,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                        String colourRep = initialsColour.value.toRadixString(16).substring(2);
                                        setState(() {
                                          picLocation = Uri.encodeFull(
                                              "https://eu.ui-avatars.com/api/?background=$colourRep&size=128&name=${profileDisplayName.text}&rounded=true&bold=true");
                                          picSrc = src;
                                        });
                                        break;
                                      case PicSrc.blank:
                                        setState(() {
                                          picLocation = blankPicUrl;
                                          picSrc = src;
                                        });
                                        break;
                                      case PicSrc.gallery:
                                        if (!kIsWeb) {
                                          final List<Media> imgList = (await ImagesPicker.pick(
                                            cropOpt: CropOption(
                                              cropType: CropType.circle,
                                            ),
                                          ))!;
                                          setState(() {
                                            picLocation = imgList.single.path;
                                            picSrc = src;
                                          });
                                        } else {
                                          final XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          if (img != null) {
                                            imgBytes = await img.readAsBytes();
                                            picMimeType = img.mimeType!;
                                            setState(() {
                                              picSrc = src;
                                            });
                                          }
                                        }
                                        break;
                                      case PicSrc.camera:
                                        if (!kIsWeb) {
                                          final List<Media> imgList = (await ImagesPicker.openCamera(
                                            cropOpt: CropOption(
                                              cropType: CropType.circle,
                                            ),
                                          ))!;
                                          setState(() {
                                            picLocation = imgList.single.path;
                                            picSrc = src;
                                          });
                                        } else {
                                          final XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
                                          if (img != null) {
                                            imgBytes = await img.readAsBytes();
                                            picMimeType = img.mimeType!;
                                            setState(() {
                                              picSrc = src;
                                            });
                                          }
                                        }
                                        break;
                                    }
                                  },
                                  value: picSrc,
                                  items: <DropdownMenuItem<PicSrc>>[
                                    DropdownMenuItem<PicSrc>(
                                      value: PicSrc.blank,
                                      child: Text(
                                        AppLocalizations.of(context)!.blank,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                    DropdownMenuItem<PicSrc>(
                                      value: PicSrc.initials,
                                      child: Text(
                                        AppLocalizations.of(context)!.initials,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                    DropdownMenuItem<PicSrc>(
                                      value: PicSrc.gallery,
                                      child: Text(
                                        AppLocalizations.of(context)!.gallery,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                    DropdownMenuItem<PicSrc>(
                                      value: PicSrc.camera,
                                      child: Text(
                                        AppLocalizations.of(context)!.camera,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                    DropdownMenuItem<PicSrc>(
                                      value: PicSrc.noChange,
                                      child: Text(
                                        AppLocalizations.of(context)!.noChange,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  AppLocalizations.of(context)!.account,
                                  textScaler: TextScaler.linear(provider(context).tsf),
                                  style: const TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Focus(
                                  onFocusChange: (bool hasFocus) {
                                    if (!hasFocus && picSrc == PicSrc.initials) {
                                      setState(() {
                                        picLocation = Uri.encodeFull(picLocation.split(nameQueryParameter).join("name=${profileDisplayName.text}"));
                                      });
                                    }
                                  },
                                  child: TextFormField(
                                    controller: profileDisplayName,
                                    decoration: InputDecoration(
                                      label: Text(
                                        AppLocalizations.of(context)!.enterDisplayName,
                                        textScaler: TextScaler.linear(provider(context).tsf),
                                      ),
                                      prefixIcon: const Icon(Icons.person),
                                      border: const OutlineInputBorder(),
                                    ),
                                    maxLength: 20,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) return AppLocalizations.of(context)!.enterDisplayName;
                                      if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.displayNameNoProfanity;
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                TextFormField(
                                  controller: profileEmail,
                                  decoration: InputDecoration(
                                    label: Text(
                                      AppLocalizations.of(context)!.enterEmail,
                                      textScaler: TextScaler.linear(provider(context).tsf),
                                    ),
                                    prefixIcon: const Icon(Icons.email),
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (String? value) {
                                    if (value == null || value == "") return AppLocalizations.of(context)!.emailEmpty;
                                    if (whitespaces.hasMatch(value)) return AppLocalizations.of(context)!.emailNoWhiteSpace;
                                    if (!value.contains("@")) return AppLocalizations.of(context)!.emailFormat;
                                    if (!value.split("@")[1].contains(".")) return AppLocalizations.of(context)!.emailFormat;
                                    if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.emailNoProfanity;
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  controller: profilePassword,
                                  obscureText: profileObscurePassword,
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
                                      icon: profileObscurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                      tooltip: profileObscurePassword
                                          ? AppLocalizations.of(context)!.showPassword
                                          : AppLocalizations.of(context)!.hidePassword,
                                      onPressed: () {
                                        setState(() {
                                          profileObscurePassword = !profileObscurePassword;
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
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (!profileFormKey.currentState!.validate()) return;
                                    setState(() {
                                      loading = true;
                                    });
                                    try {
                                      if (picSrc.type() == 'url') {
                                        await provider(context).user!.update({
                                          "displayName": profileDisplayName.text,
                                          "email": profileEmail.text,
                                          "photoUrl": picLocation,
                                        });
                                      } else {
                                        String photoUrl = "";
                                        ListResult currentPic = await storage.ref("users/${auth.currentUser!.uid}").listAll();
                                        if (currentPic.items.isNotEmpty) {
                                          await currentPic.items.single.delete();
                                        }
                                        if (!kIsWeb) {
                                          await storage
                                              .ref("users/${auth.currentUser!.uid}/${File(picLocation).path.split("/").last}")
                                              .putFile(File(picLocation));
                                          photoUrl = await storage
                                              .ref("users/${auth.currentUser!.uid}/${File(picLocation).path.split("/").last}")
                                              .getDownloadURL();
                                        } else {
                                          await storage
                                              .ref("users/${auth.currentUser!.uid}/profile_pic.${picMimeType.split("/").last}")
                                              .putData(imgBytes!);
                                          photoUrl = await storage
                                              .ref("users/${auth.currentUser!.uid}/profile_pic.${picMimeType.split("/").last}")
                                              .getDownloadURL();
                                        }
                                        await provider(context).user!.update({
                                          "displayName": profileDisplayName.text,
                                          "email": profileEmail.text,
                                          "photoUrl": photoUrl,
                                        });
                                      }
                                    } on FirebaseException catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(e.message!),
                                        ),
                                      );
                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.saveChanges,
                                    textScaler: TextScaler.linear(provider(context).tsf),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                loading
                                    ? CircularProgressIndicator(
                                        color: isDarkMode(context) ? Colors.grey : Colors.grey[900],
                                      )
                                    : blank,
                                const SizedBox(height: 36.0),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool res = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              AppLocalizations.of(context)!.areYouSure,
                                              textScaler: TextScaler.linear(provider(context).tsf),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.areYouSureDelete,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  AppLocalizations.of(context)!.tsAndCs,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                  style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                )
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(false);
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.cancel,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                  style: TextStyle(
                                                    color: theme.red.colour,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(true);
                                                },
                                                child: Text(
                                                  AppLocalizations.of(context)!.ok,
                                                  textScaler: TextScaler.linear(provider(context).tsf),
                                                  style: TextStyle(
                                                    color: theme.green.colour,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ) ??
                                        false;
                                    if (res) {
                                      await provider(context).user!.ref.set({
                                        "displayName": provider(context).user!.displayName,
                                        "photoUrl": provider(context).user!.photoUrl,
                                      });
                                      QuerySnapshot friends = await firestore
                                          .collection("friends")
                                          .where(
                                            "users",
                                            arrayContains: provider(context).user!.ref,
                                          )
                                          .get();
                                      for (QueryDocumentSnapshot friend in friends.docs) {
                                        await friend.reference.delete();
                                      }
                                      QuerySnapshot passPlays = await firestore
                                          .collection("passPlay")
                                          .where("host", isEqualTo: provider(context).user!.ref)
                                          .get();
                                      for (QueryDocumentSnapshot passPlay in passPlays.docs) {
                                        await passPlay.reference.delete();
                                      }
                                      await provider(context).updateUser(null);
                                      await auth.currentUser!.delete();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const LoginPage(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.red.colour,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.deleteAccount,
                                    textScaler: TextScaler.linear(provider(context).tsf),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(provider(context).user!.photoUrl),
                        radius: 90.0,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.reAuth,
                      textScaler: TextScaler.linear(provider(context).tsf),
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 16.0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.reAuthDesc,
                        textScaler: TextScaler.linear(provider(context).tsf),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: min(500.0, MediaQuery.of(context).size.width),
                        ),
                        child: Form(
                          key: reAuthFormKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (String? value) {
                                    if (value == null || value == "") return AppLocalizations.of(context)!.emailEmpty;
                                    if (!value.contains("@")) return AppLocalizations.of(context)!.emailFormat;
                                    if (!value.split("@")[1].contains(".")) return AppLocalizations.of(context)!.emailFormat;
                                    if (ProfanityFilter().hasProfanity(value)) return AppLocalizations.of(context)!.emailNoProfanity;
                                    return null;
                                  },
                                  controller: reAuthEmail,
                                  decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!.enterEmail),
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.email),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (String? value) {
                                    if (value == null || value == "") return AppLocalizations.of(context)!.passwordEmpty;
                                    if (value.length < 10) return AppLocalizations.of(context)!.passwordLength;
                                    if (!password.hasMatch(value)) return AppLocalizations.of(context)!.passwordCharacters;
                                    return null;
                                  },
                                  obscureText: reAuthObscurePassword,
                                  controller: reAuthPassword,
                                  decoration: InputDecoration(
                                    label: Text(AppLocalizations.of(context)!.enterPassword),
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: reAuthObscurePassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                      tooltip: reAuthObscurePassword
                                          ? AppLocalizations.of(context)!.showPassword
                                          : AppLocalizations.of(context)!.hidePassword,
                                      onPressed: () {
                                        setState(() {
                                          reAuthObscurePassword = !reAuthObscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary.colour,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () async {
                        if (!reAuthFormKey.currentState!.validate()) return;
                        setState(() {
                          loading = true;
                        });
                        try {
                          await auth.currentUser!.reauthenticateWithCredential(
                            EmailAuthProvider.credential(
                              email: reAuthEmail.text,
                              password: reAuthPassword.text,
                            ),
                          );
                          setState(() {
                            profileDisplayName.text = provider(context).user!.displayName;
                            profileEmail.text = provider(context).user!.email;
                            profilePassword.text = reAuthPassword.text;
                            isReAuth = true;
                            loading = false;
                          });
                        } on FirebaseException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message!),
                            ),
                          );
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.reAuthVerb,
                        textScaler: TextScaler.linear(provider(context).tsf),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    loading ? defaultLoadingIndicator : blank,
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
    );
  }
}
