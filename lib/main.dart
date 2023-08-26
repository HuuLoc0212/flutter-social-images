import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Imagesio/firebase_options.dart';
import 'package:Imagesio/providers/screen_provider.dart';
import 'package:Imagesio/screens/auth/first_open.dart';
import 'package:Imagesio/screens/auth/login.dart';
import 'package:Imagesio/screens/auth/register.dart';
import 'package:Imagesio/screens/edit_profile.dart';
import 'package:Imagesio/screens/home/home_layout.dart';
import 'package:Imagesio/screens/home/splash_screen.dart';
import 'package:Imagesio/screens/post/add_post.dart';
import 'package:Imagesio/screens/post/comment_page.dart';
import 'package:Imagesio/screens/post/edit-post.dart';
import 'package:Imagesio/screens/post/post_page.dart';
import 'package:Imagesio/screens/profile_page.dart';
import 'package:Imagesio/screens/root.dart';
import 'package:Imagesio/screens/search_screen.dart';
import 'package:Imagesio/screens/user_profile.dart';
import 'package:Imagesio/services/auth.dart';
import 'package:provider/provider.dart';

// import 'package:Imagesio/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>(
          create: (context) => AuthService().firebaseUser,
          initialData: null,
        ),
        ChangeNotifierProvider<ScreenProvider>(
          create: (context) => ScreenProvider(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            backgroundColor: const Color(0xFFFEFEFE),
            fontFamily: 'Roboto',
          ),
          home: const SplashScreen(),
          routes: {
            // Root.routeName: (context) => const Root(),
            FirstOpen.routeName: (context) => const FirstOpen(),
            HomeLayoutPage.routeName: (context) => const HomeLayoutPage(),
            LoginPage.routeName: (context) => const LoginPage(),
            RegisterPage.routeName: (context) => const RegisterPage(),
            PostPage.routeName: (context) => const PostPage(),
            AddPostPage.routeName: (context) => const AddPostPage(),
            EditPostPage.routeName: (context) => const EditPostPage(),
            CommentPage.routeName: (context) => const CommentPage(),
            UserProfile.routeName: (context) => const UserProfile(),
            EditProfile.routeName: (context) => const EditProfile(),
            SearchScreen.routeName: (context) => const SearchScreen(),
          }),
    );
  }
}
