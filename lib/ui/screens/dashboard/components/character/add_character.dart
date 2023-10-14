// ignore_for_file: use_build_context_synchronously

import 'package:disney_voting/controllers/characters_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/ui/widgets/app_images.dart';
import 'package:disney_voting/ui/widgets/custom_appbar.dart';
import 'package:disney_voting/ui/widgets/custom_button.dart';
import 'package:disney_voting/ui/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../config/config.dart';

class AddCharacterScreen extends StatefulWidget {
  const AddCharacterScreen({super.key});

  @override
  State<AddCharacterScreen> createState() => _AddCharacterScreenState();
}

class _AddCharacterScreenState extends State<AddCharacterScreen> {
  late final TextEditingController _name, _desc;
  final _formKey = GlobalKey<FormState>();
  late final CharacterController _controller;

  @override
  void initState() {
    _controller = context.read<CharacterController>();

    _name = TextEditingController();
    _desc = TextEditingController();
    _name.addListener(() {
      _controller.request = _controller.request.copyWith(name: _name.text);
    });
    _desc.addListener(() {
      _controller.request = _controller.request.copyWith(desc: _desc.text);
    });

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppbar(
          title: 'Add Character',
          implyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: Sizes.s20),
              Consumer<CharacterController>(
                  builder: (context, controller, child) {
                return CameraPlaceholderWidget(
                  onTap: () {
                    controller.pickImage(ImageSource.gallery);
                  },
                  file: controller.image,
                  image: null,
                  height: 200,
                  width: double.infinity,
                );
              }),
              const SizedBox(height: Sizes.s20),
              CustomTextFormField(
                controller: _name,
                hint: 'Character Name',
                validator: (val) => Validator.valueExists(val!),
              ),
              const SizedBox(height: Sizes.s20),
              SizedBox(
                height: 100,
                child: CustomTextFormField(
                  expands: true,
                  controller: _desc,
                  hint: 'Character Desc',
                  maxLines: null,
                  validator: (val) => Validator.valueExists(val!),
                ),
              ),
              const SizedBox(height: Sizes.s20),
              Consumer<CharacterController>(builder: (context, char, child) {
                return char.states.status == Status.buttonLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        onPressed: () => _validateAndSend(),
                        width: double.infinity,
                        marginHorizontal: Sizes.s20,
                        child: const Text(
                          'Add Character',
                        ),
                      );
              }),
            ]),
          ),
        ));
  }

  void _validateAndSend() async {
    if (_controller.image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pick an image')));
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await _controller.addCharacter();

    if (_controller.states.status == Status.completed) {
      Navigator.pop(context);
    }
  }
}
