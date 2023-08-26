import 'package:flutter/material.dart';

class Suggestion extends StatelessWidget {
  const Suggestion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 300,
          color: Colors.red,
          child: Wrap(
            direction: Axis.horizontal,
            children: <Widget>[
              TextButton(
                onPressed: () {},
                child: Image.network(
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
              TextButton(
                onPressed: () {},
                child: Image.network(
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
              TextButton(
                onPressed: () {},
                child: Image.network(
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
              TextButton(
                onPressed: () {},
                child: Image.network(
                    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
