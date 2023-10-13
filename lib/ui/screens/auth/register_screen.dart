import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disney_voting/config/palette.dart';
import 'package:disney_voting/config/values.dart';
import 'package:disney_voting/controllers/auth_controller.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/validator.dart';
import '../../../controllers/states.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _lastNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late double sizeBetween;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    sizeBetween = height / 20;
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Register as Administrator',
        implyLeading: true,
      ),
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              CustomTextFormField(
                controller: _nameController,
                hint: 'Full Name',
                validator: (val) => Validator.valueExists(val!),
              ),
              const SizedBox(height: 20),
              // CustomTextFormField(
              //   controller: _lastNameController,
              //   hint: 'Last Name',
              //   validator: (val) => Validator.valueExists(val!),
              // ),
              // const SizedBox(height: 20),
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
                validator: (val) => Validator.passwordCorrect(val!),
                keyboard: TextInputType.visiblePassword,
                isPassword: true,
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
                        child: const Text('Sign Up'),
                      );
              }),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      textStyle: const TextStyle(fontWeight: FontWeight.w300),
                      foregroundColor: Palette.primary),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, Routes.login),
                  child: const Text('Sign in with existing account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignInScreen() async {
    Navigator.of(context).pushNamed(Routes.login);
  }

  void _validateAndSend() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    final AuthController controller = context.read<AuthController>();

    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    await controller.signUp(SignUpRequest(_nameController.text,
        _emailController.text, _passwordController.text, timestamp));
    if (mounted && controller.states.status == Status.completed) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(controller.states.message!)));
    }
  }
}
