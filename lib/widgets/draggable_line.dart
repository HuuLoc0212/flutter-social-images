import 'package:flutter/material.dart';

class DraggableLine extends StatelessWidget {
  const DraggableLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(24),
        ),
      ),
    );
  }
}
