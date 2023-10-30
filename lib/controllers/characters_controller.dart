import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:disney_voting/config/config.dart';
import 'package:disney_voting/controllers/base_controller.dart';
import 'package:disney_voting/controllers/states.dart';
import 'package:disney_voting/data/repository/repository.dart';
import 'package:disney_voting/data/requests/requests.dart';
import 'package:disney_voting/data/responses/responses.dart';
import 'package:image_picker/image_picker.dart';

class CharacterController extends BaseController {
  Repository _repository;

  CharacterController(this._repository);
  final ImagePicker _picker = ImagePicker();
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  AddCharacterRequest request = AddCharacterRequest('', '', '', '', 0, []);
  File? image;
  DisneyCharacter? disneyCharacter;
  int currentIndex = 0;
  DisneyCharacter? selectedDisneyCharacter;

  List<DisneyCharacter> charList = [];

  setIndex(int i) {
    currentIndex = i;
    selectedDisneyCharacter = charList[i];
    notifyListeners();
  }

  setName(String val) {
    request = request.copyWith(name: val);
  }

  setDesc(String val) {
    request = request.copyWith(desc: val);
  }

  _setIdAndTimestamp() {
    request = request.copyWith(id: timestamp.toString(), timestamp: timestamp);
  }

  getCharaters() async {
    setState(States.loading(Constants.loading));

    final result = await _repository.getCharacters();
    if (result.isRight()) {
      charList = result.asRight();
      selectedDisneyCharacter = charList[currentIndex];
      setState(States.completed(charList));
    } else {
      final message = result.asLeft();

      setState(States.error(message));
    }
  }

  deleteCharater(String id) async {
    setState(States.loading(Constants.loading));

    final result = await _repository.deleteCharacter(id);
    if (result.isRight()) {
      setState(States.completed(charList));
    } else {
      final message = result.asLeft();

      setState(States.error(message));
    }
  }

  addCharacter([String? id, String? myImage]) async {
    setState(States.buttonLoading(Constants.loading));
    _setIdAndTimestamp();
    final result = await _repository.addCharacter(
        request, image, id ?? request.id, myImage);
    if (result.isRight()) {
      log('Right');
      String success = result.asRight();
      _resetValues();
      setState(States.completed(success));
    } else {
      log('Left');

      String failure = result.asLeft();
      setState(States.error(failure));
    }
  }

  updateCharacter([String? id, String? myImage]) async {
    setState(States.buttonLoading(Constants.loading));
    _setIdAndTimestamp();
    final result = await _repository.updateCharacter(
        request, image, id ?? request.id, myImage);
    if (result.isRight()) {
      log('Right');
      String success = result.asRight();
      _resetValues();
      setState(States.completed(success));
    } else {
      log('Left');

      String failure = result.asLeft();
      setState(States.error(failure));
    }
  }

  getCharacterById(String id) async {
    setState(States.loading(Constants.loading));
    final result = await _repository.getCharactersById(id);
    if (result.isRight()) {
      disneyCharacter = result.asRight();
      setState(States.completed(disneyCharacter));
    } else {
      String failure = result.asLeft();
      setState(States.error(failure));
    }
  }

  Future<File?> pickImage(ImageSource source) async {
    XFile? xImage = await _picker.pickImage(source: source);
    if (xImage != null) {
      image = File(xImage.path);
      notifyListeners();
    }
    return null;
  }

  _resetValues() {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    image = null;
  }
}
