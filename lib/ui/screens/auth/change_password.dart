// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';

import 'package:disney_voting/config/palette.dart';
import 'package:disney_voting/config/values.dart';
import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/config.dart';
import '../../../config/validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  User? currentUser = instance<FirebaseAuth>().currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPassword = true;
  bool isPasswordConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                // if (currentUser == null)
                CustomTextFormField(
                  controller: _passController,
                  hint: 'New Password',
                  isPassword: isPassword,
                  suffix: IconButton(
                    icon: Icon(
                        isPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                  ),
                  validator: (val) => Validator.passwordCorrect(val!),
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _confirmPassController,
                  hint: 'Confirm Password',
                  isPassword: isPasswordConfirm,
                  suffix: IconButton(
                    icon: Icon(isPasswordConfirm
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordConfirm = !isPasswordConfirm;
                      });
                    },
                  ),
                  validator: (val) => val! == _passController.text
                      ? null
                      : 'Passwords didn\'t matched',
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Consumer<AuthController>(builder: (context, auth, child) {
                  return auth.states.status == Status.buttonLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          onPressed: _validateAndSend,
                          width: double.infinity,
                          marginHorizontal: Sizes.s20,
                          child: const Text('Update Password'),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSend() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final AuthController controller = context.read<AuthController>();
    await controller.updatePassword(_passController.text);
    if (mounted && controller.states.status == Status.completed) {
      bool success = await context.read<AuthController>().signOut();
      log(success.toString());
      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(controller.states.data!)));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(controller.states.message!)));
    }
  }
}
