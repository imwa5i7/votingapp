import 'package:disney_voting/config/palette.dart';
import 'package:disney_voting/config/values.dart';
import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/validator.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
          title: 'Sign in as Administrator', implyLeading: true),
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
                CustomTextFormField(
                  controller: _emailController,
                  hint: 'Email',
                  validator: (val) => Validator.validateEmail(val!),
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: _isPassword,
                  suffix: IconButton(
                    icon: Icon(
                        _isPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPassword = !_isPassword;
                      });
                    },
                  ),
                  validator: (val) => Validator.passwordCorrect(val),
                  keyboard: TextInputType.visiblePassword,
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
                          child: const Text('Sign In'),
                        );
                }),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topCenter,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Palette.primary,
                      textStyle: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, Routes.register),
                    child: const Text(
                      'Or Sign up with new account',
                    ),
                  ),
                ),
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
    await controller
        .signIn(SignInRequest(_emailController.text, _passwordController.text));
    if (mounted && controller.states.status == Status.completed) {
      Navigator.popAndPushNamed(context, Routes.dashboard);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(controller.states.message!)));
    }
  }
}
