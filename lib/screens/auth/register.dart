import 'package:flutter/material.dart';
import 'package:Imagesio/services/auth.dart';
import 'package:Imagesio/shared/constants.dart';
import 'package:Imagesio/widgets/custom_divider.dart';
import 'package:Imagesio/widgets/long_button.dart';
import 'package:Imagesio/widgets/prefix_icon.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formRegister = GlobalKey<FormState>();
  bool _obscureText = true;

  String email = '';
  String username = '';
  String password = '';
  String confirmPassword = '';

  handleSignUp() async {
    if (_formRegister.currentState!.validate()) {
      if (await AuthService().checkUsername(username) == true) {
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
            .signUp(email: email, password: password, username: username)
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(32.0, 30.0, 32.0, 12.0),
            children: [
              const Text(
                'Be a member of',
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w100),
              ),
              const Text(
                'Imagesio',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40.0),
              Form(
                key: _formRegister,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return "Enter your email";
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Email",
                        hintText: "Enter your email",
                        prefixIcon: const CustomPrefixIcon(icon: Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      onChanged: (val) {
                        setState(() => username = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return "Enter your username";
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Username",
                        hintText: "Enter your username",
                        prefixIcon:
                            const CustomPrefixIcon(icon: Icons.account_circle),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      obscureText: _obscureText,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Password",
                        hintText: "Enter your password",
                        prefixIcon: const CustomPrefixIcon(icon: Icons.key),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      obscureText: _obscureText,
                      onChanged: (val) {
                        setState(() => confirmPassword = val);
                      },
                      validator: (String? val) {
                        if (val != null && val.isEmpty) {
                          return 'Enter password';
                        }
                        if (val != password) {
                          return 'Password does not match';
                        }
                        return null;
                      },
                      decoration: textInputDecoration.copyWith(
                        labelText: "Confirm password",
                        hintText: "Confirm password",
                        prefixIcon: const CustomPrefixIcon(icon: Icons.key),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    // if (_formKey.currentState!.validate()) {}
                    LongButton(text: 'Sign up', onPress: handleSignUp)
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const CustomDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 50,
                    height: 50,
                    child: const Image(
                      image: AssetImage('assets/images/facebook-logo.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 50,
                    height: 50,
                    child: const Image(
                      image: AssetImage('assets/images/google-logo.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 50,
                    height: 50,
                    child: const Image(
                      image: AssetImage('assets/images/apple-logo.png'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
