import 'dart:developer';

import 'package:disney_voting/config/palette.dart';
import 'package:disney_voting/config/values.dart';
import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/config.dart';
import '../../../config/routes.dart';
import '../../../config/validator.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordScreenState();
  }
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  User? currentUser = instance<FirebaseAuth>().currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                  controller: _emailController,
                  hint: 'Email',
                  validator: (val) => Validator.validateEmail(val!),
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
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
                          child: const Text('Change Password'),
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
    // log(currentUser!.email!);
    await controller.resetPassword(_emailController.text);
    if (mounted && controller.states.status == Status.completed) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(controller.states.data!)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(controller.states.message!)));
    }
  }
}
