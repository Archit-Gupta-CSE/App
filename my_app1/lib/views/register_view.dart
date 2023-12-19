// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:my_app1/constants/routes.dart';
import 'package:my_app1/services/auth/auth_exceptions.dart';
import 'package:my_app1/services/auth/auth_service.dart';
import 'package:my_app1/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color.fromARGB(255, 8, 109, 167),
      ),
      body: Column(
        children: [
          Container(
            height: 5,
          ),
          Center(
            child: SizedBox(
              width: 300.0,
              child: TextField(
                controller: _email,
                decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 208, 92, 34),
                      width: 2,
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.email,
                  ),
                ),
                enableSuggestions: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                    fontSize: 15.0, height: 1.5, color: Colors.black),
              ),
            ),
          ),
          Container(
            height: 5,
          ),
          Center(
            child: SizedBox(
              width: 300.0,
              child: TextField(
                controller: _password,
                obscureText: _obscureText,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: 'Enter Your Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 208, 92, 34),
                          width: 2,
                        )),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )),
                style: const TextStyle(
                    fontSize: 15.0, height: 1.5, color: Colors.black),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed(verifyRoute);
              } on WeakPasswordException {
                showErrorDialog(
                  context,
                  'Weak Password !',
                );
              } on EmailAlreadyInUseException {
                showErrorDialog(
                  context,
                  'Email is already is use !',
                );
              } on InvalidEmailException {
                showErrorDialog(
                  context,
                  'This is an invalid email address !',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Failed to Register',
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already Registered ??'))
        ],
      ),
    );
  }
}
