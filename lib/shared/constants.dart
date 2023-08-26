import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.all(16.0),
  fillColor: Colors.grey[200],
  filled: true,
  enabledBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide(
      color: Colors.white,
      width: 0.0,
    ),
  ),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(12.0),
    ),
    borderSide: BorderSide(
      color: Colors.blue,
      width: 1.0,
    ),
  ),
  hintStyle: const TextStyle(
    fontSize: 12.0,
    color: Colors.grey,
  ),
  isDense: true,
);

const white = Colors.white;
const black = Colors.black87;
const hyperlinkColor = Color(0xFF00376B);
const secondaryColor = Color(0xFFDBDBDB);
const secondaryDarkColor = Color(0xFF8E8E8E);

final buttonDecoration = BoxDecoration(
  color: white,
  border: Border.all(
    color: secondaryColor,
    width: 0.8,
  ),
  borderRadius: BorderRadius.circular(4),
);
