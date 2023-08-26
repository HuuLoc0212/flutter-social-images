import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Imagesio/screens/home/home_layout.dart';
import 'package:Imagesio/services/auth.dart';
import 'package:Imagesio/widgets/long_button.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // user needs to be created
    isEmailVerified = AuthService().user!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (_) {
        checkEmailVerified();
        print('check mail');
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    // call after email verification
    await AuthService().user!.reload();

    setState(() {
      isEmailVerified = AuthService().user!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      await AuthService().user!.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const HomeLayoutPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/images/verify_email.png')),
              const SizedBox(
                height: 40.0,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.w700,
                      fontSize: 16.0,
                    ),
                    children: [
                      const TextSpan(
                          text: 'A verification email has been sent to '),
                      TextSpan(
                        text: '${AuthService().user!.email}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: Colors.blue),
                      )
                    ]),
              ),
              const SizedBox(
                height: 40.0,
              ),
              LongButton(
                  text: 'Resend Email',
                  onPress: canResendEmail ? sendVerificationEmail : () {}),
              TextButton(
                onPressed: () {
                  sendVerificationEmail();
                },
                style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50.0)),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
