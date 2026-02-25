import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'src/auth/screens/auth_gate.dart';
import 'src/core/config/app_config.dart';
import 'main.dart';

void main() async {
  await initializeApp(Environment.prod);
  runApp(const PhonicsKidsProApp());
}
