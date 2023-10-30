// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

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

class UpdateCharacter extends StatefulWidget {
  final String? id;
  const UpdateCharacter({super.key, required this.id});

  @override
  State<UpdateCharacter> createState() => _UpdateCharacterState();
}

class _UpdateCharacterState extends State<UpdateCharacter> {
  late final TextEditingController _name, _desc;
  final _formKey = GlobalKey<FormState>();
  late final CharacterController _controller;

  @override
  void initState() {
    _name = TextEditingController();
    _desc = TextEditingController();
    _controller = context.read<CharacterController>();
    _controller.init();
    Future.delayed(Duration.zero, () {
      _getCharacterById();
    });
    super.initState();
  }

  _getCharacterById() async {
    await _controller.getCharacterById(widget.id!);
    if (_controller.states.status == Status.completed) {
      log(_controller.states.status.toString());
      _name.text = _controller.disneyCharacter!.name!;
      _desc.text = _controller.disneyCharacter!.desc!;
      _name.addListener(() {
        _controller.request = _controller.request.copyWith(name: _name.text);
      });
      _desc.addListener(() {
        _controller.request = _controller.request.copyWith(desc: _desc.text);
      });
    }
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
        title: 'Update Character',
        implyLeading: true,
      ),
      body:
          Consumer<CharacterController>(builder: (context, controller, child) {
        return controller.states.status == Status.loading ||
                controller.states.status == Status.initial
            ? const Center(child: CircularProgressIndicator())
            : controller.states.status == Status.error
                ? Center(child: Text(controller.states.message!))
                : controller.states.status == Status.completed ||
                        controller.states.status == Status.buttonLoading
                    ? SingleChildScrollView(
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
                                image: widget.id != null
                                    ? controller.disneyCharacter!.image
                                    : null,
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
                            Consumer<CharacterController>(
                                builder: (context, char, child) {
                              return char.states.status == Status.buttonLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : CustomButton(
                                      onPressed: () => _validateAndSend(),
                                      width: double.infinity,
                                      marginHorizontal: Sizes.s20,
                                      child: const Text(
                                        'Update Character',
                                      ),
                                    );
                            }),
                          ]),
                        ),
                      )
                    : const SizedBox();
      }),
    );
  }

  void _validateAndSend() async {
    if (widget.id == null) {
      if (_controller.image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Pick an image')));
        return;
      }
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    await _controller.updateCharacter(
        widget.id, _controller.disneyCharacter!.image);

    if (_controller.states.status == Status.completed) {
      Navigator.pop(context);
    }
  }
}
