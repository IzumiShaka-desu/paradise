import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

abstract class BaseFireStorageService {
  Future<String> uploadImage(File file, String path);
  Future<String> getUrl(String child);
  Future<File> getTempFile(String url);
  Future<void> delete(String path);
}

class FireStorageService implements BaseFireStorageService {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  StorageReference get storageRef => firebaseStorage.ref();
  @override
  Future<String> getUrl(String childPath) {
    return storageRef.child(childPath).getDownloadURL();
  }

  @override
  Future<String> uploadImage(File file, String path) async {
    StorageUploadTask task = storageRef.child(path).putFile(file);
    String result = await (await task.onComplete).ref.getDownloadURL();
    return result;
  }

  @override
  Future<File> getTempFile(String url) async {
    String path = Directory.systemTemp.path;

    StorageReference reference = await firebaseStorage.getReferenceFromUrl(url);
    String fileName = await reference.getName();
    File file = File('$path/$fileName');
    return file.writeAsBytes((await reference.getData(10000)));
  }

  @override
  Future<void> delete(String path) async{
    print(path);
    (await firebaseStorage.getReferenceFromUrl(path)).delete();
}}
