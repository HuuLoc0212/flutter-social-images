import 'package:flutter/material.dart';
import 'package:Imagesio/screens/auth/login.dart';
import 'package:Imagesio/screens/auth/register.dart';
import 'package:Imagesio/widgets/long_button.dart';

class FirstOpen extends StatelessWidget {
  static const routeName = 'first';
  const FirstOpen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    goToLoginScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
      );
    }

    goToRegisterScreen() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const RegisterPage(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/logo.png'),
                          height: 150.0,
                        ),
                        Column(
                          children: const [
                            Text(
                              'Imagesio',
                              style: TextStyle(
                                fontSize: 32.0,
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              'The world appears in your eyes',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              Center(
                child: Column(
                  children: [
                    LongButton(
                        text: 'Create your account',
                        onPress: goToRegisterScreen),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ElevatedButton(
                      onPressed: goToLoginScreen,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        child: Text(
                          'Already a member?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.0),
                        ),
                        elevation: 0,
                        minimumSize: const Size(300.0, 0.0),
                      ),
                    )
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
