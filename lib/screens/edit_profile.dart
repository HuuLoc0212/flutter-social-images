import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Imagesio/models/author.dart';
import 'package:Imagesio/services/auth.dart';
import 'package:Imagesio/services/util.dart';
import 'package:Imagesio/shared/constants.dart';
import 'package:Imagesio/widgets/long_button.dart';
import 'package:Imagesio/widgets/prefix_icon.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit-profile';
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formEditProfile = GlobalKey<FormState>();

  late String avatarUrl;
  late String currentUsername;

  File? newAvatar;

  TextEditingController displayName = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();

  handleSubmit() async {
    if (_formEditProfile.currentState!.validate()) {
      if (username.text != currentUsername &&
          await AuthService().checkUsername(username.text) == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Username is exist. Please choose another.',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      } else {
        AuthService()
            .updateProfile(newAvatar, displayName.text, username.text, bio.text)
            .then((result) {
          if (result == null) {
            Navigator.pop(context);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    Author currentUser = arg['currentUser'];

    currentUsername = currentUser.username!;

    displayName.text = currentUser.displayName ?? '';
    username.text = currentUser.username!;
    bio.text = currentUser.bio ?? '';
    avatarUrl = currentUser.avatar;

    handleChangeAvatar(ImageSource source) async {
      File? image = await Util().getImage(source);

      if (image != null) {
        setState(() {
          newAvatar = image;
        });
      }
    }

    showModalSheet() {
      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        isScrollControlled: false, // chi co the keo xuong
        isDismissible: true, // co the keo xuong va an vao auto out
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      handleChangeAvatar(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Camera',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0.0, 24.0),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 2.0,
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: TextButton(
                    onPressed: () {
                      handleChangeAvatar(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Gallary',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0.0, 24.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(FontAwesomeIcons.angleLeft),
              color: Colors.blue,
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(32.0, 30.0, 32.0, 12.0),
              children: [
                GestureDetector(
                  onTap: showModalSheet,
                  child: newAvatar != null
                      ? Container(
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          child: Image.file(
                            newAvatar!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          child: CachedNetworkImage(
                            width: 150,
                            height: 150,
                            imageUrl: avatarUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextButton(
                  onPressed: showModalSheet,
                  child: const Text(
                    'Change Avatar',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 40.0),
                Form(
                  key: _formEditProfile,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: displayName,
                        decoration: textInputDecoration.copyWith(
                          hintText: "Enter your display name",
                          prefixIcon: const CustomPrefixIcon(
                              icon: FontAwesomeIcons.signature),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: username,
                        validator: (String? val) {
                          String pattern = r'^[a-zA-Z0-9_.-]*$';
                          RegExp regExp = RegExp(pattern);

                          if (val != null && val.isEmpty) {
                            return "Username can not be empty.";
                          }
                          if (val!.length < 4) {
                            return "Username must be longer than 4 characters.";
                          }
                          if (val.length > 20) {
                            return "Username can not be longer than 20 characters.";
                          }
                          if (!regExp.hasMatch(val)) {
                            return "Username is not valid (a-z A-Z 0-9 - . _)";
                          }
                          return null;
                        },
                        decoration: textInputDecoration.copyWith(
                          hintText: "Enter your username",
                          prefixIcon:
                              const CustomPrefixIcon(icon: FontAwesomeIcons.at),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        maxLines: 6,
                        maxLength: 300,
                        controller: bio,
                        validator: (String? val) {
                          if (val != null && val.length > 300) {
                            return "Bio can not be longer than 300 characters.";
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 14.0),
                        decoration: textInputDecoration.copyWith(
                          hintText: "Enter your bio",
                          prefixIcon: const CustomPrefixIcon(
                              icon: FontAwesomeIcons.quoteLeft),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      LongButton(text: 'Save', onPress: handleSubmit)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
