import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../data/repository/repository.dart';

GetIt instance = GetIt.instance;

initAppModule() {
  instance.registerSingleton(FirebaseAuth.instance);
  instance.registerSingleton(FirebaseFirestore.instance);
  instance.registerSingleton(FirebaseStorage.instance);

  instance.registerLazySingleton<Repository>(
      () => RepoImpl(instance(), instance(), instance()));
}
