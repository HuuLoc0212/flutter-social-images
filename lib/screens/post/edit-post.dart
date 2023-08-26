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

class EditPostPage extends StatefulWidget {
  static const routeName = '/edit-post';
  const EditPostPage({Key? key}) : super(key: key);

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final _formEditPost = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User>(context);

    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    String postId = arg['postId'];
    String title = arg['title'];
    String description = arg['description'];
    String categories = arg['categories'];
    String imageUrl = arg['imageUrl'];

    setState(() {
      titleController.text = title;
      descriptionController.text = description;
      categoriesController.text = categories;
    });

    void handleSubmit() async {
      if (_formEditPost.currentState!.validate()) {
        bool result = await PostService().editPost(postId, titleController.text,
            descriptionController.text, categoriesController.text);

        if (result) {
          Navigator.pop(context);
        }
      }
    }

    void handleDelete() {
      PostService().deletePost(postId);
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.blue,
        title: const Text('Edit Post'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: handleDelete,
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.network(imageUrl),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Form(
                key: _formEditPost,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Title",
                        hintText: "Enter title",
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: descriptionController,
                      decoration: textInputDecoration.copyWith(
                        labelText: "Description",
                        hintText: "Enter description",
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: categoriesController,
                      validator: (String? val) {
                        RegExp regExp = RegExp(r'^[A-Za-z0-9,\s]+$');
                        if (val != null && val.isEmpty) {
                          return "Please enter at least one category";
                        } else if (!regExp.hasMatch(val!)) {
                          return 'Valid character (a-z, A-Z, 0-9 and ,)';
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Categories",
                        hintText: "Enter categories",
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    LongButton(text: 'Save', onPress: handleSubmit)
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
