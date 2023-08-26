import 'package:flutter/material.dart';

class CustomPrefixIcon extends StatelessWidget {
  final IconData icon;
  const CustomPrefixIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 20,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
          color: Colors.blue[100],
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
