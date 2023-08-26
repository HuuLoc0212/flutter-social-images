import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Imagesio/services/post.dart';
import 'package:Imagesio/services/util.dart';
import 'package:Imagesio/shared/constants.dart';
import 'package:Imagesio/widgets/long_button.dart';
import 'package:Imagesio/widgets/prefix_icon.dart';
import 'package:provider/provider.dart';

class AddPostPage extends StatefulWidget {
  static const routeName = 'add-post';
  const AddPostPage({Key? key}) : super(key: key);

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _formAddPost = GlobalKey<FormState>();

  String title = '';
  String description = '';
  String categories = '';

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User>(context);
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    File image = arg['image'];

    void handleSubmit() async {
      if (_formAddPost.currentState!.validate()) {
        // print('$title, $description, $categories');
        String postId = await PostService()
            .createPost(title, description, categories, image, user.uid);

        if (postId != '') {
          Navigator.pushReplacementNamed(context, '/post', arguments: {
            'postId': postId,
          });
        }
      }
    }

    handleChangeImage(ImageSource source) async {
      File? newImage = await Util().getImage(source);

      if (newImage != null) {
        Navigator.pushReplacementNamed(context, 'add-post', arguments: {
          'image': newImage,
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.blue,
        title: const Text('New Post'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                  onTap: () => handleChangeImage(ImageSource.gallery),
                  child: SizedBox(
                      width: 200, height: 200, child: Image.file(image))),
              const SizedBox(
                height: 16.0,
              ),
              Form(
                key: _formAddPost,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (val) {
                        setState(() => title = val);
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Title",
                        hintText: "Enter title",
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => description = val);
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Description",
                        hintText: "Enter description",
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => categories = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return "Please enter at least one category";
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Categories",
                        hintText: "Enter categories",
                      ),
                    ),

                    const SizedBox(height: 24.0),
                    // if (_formKey.currentState!.validate()) {}
                    LongButton(text: 'Create', onPress: handleSubmit)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
