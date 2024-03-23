import 'package:difund_admin/login.dart';
import 'package:difund_admin/org.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return //if user logined goto home else sign in
        FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : const OrgPage();
  }
}
