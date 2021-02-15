import 'dart:io';
import 'dart:convert';
import 'package:product_app/data/api_data.dart';
import 'package:product_app/data/shared_preferences.dart';
import 'package:product_app/model/product_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:logging/logging.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ProductCreateBloc {
  final ApiData _apiData;
  final Preferences _preferences;

  ProductCreateBloc({
    ApiData apiData,
    Preferences preferences,
  })  : _apiData = apiData ?? ApiData(),
        _preferences = preferences ?? Preferences();
  final log = Logger('ProductCreateBloc');
  final createUpdate = BehaviorSubject<Product>();
  final photo = BehaviorSubject<String>();

  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isEmpty = BehaviorSubject<bool>.seeded(false);

  createUpdateProduct(String code, String name, int price) async {
    isLoading.add(true);
    try {
      //Get access token
      String accessToken = await _preferences.getAccessToken();
      Product response = await _apiData.createUpdateProduct(
          code, name, price, accessToken);
      createUpdate.add(response);
    } catch (e) {
      createUpdate.addError(e);
    } finally {
      isLoading.add(false);
    }
  }

  Future<void> pickPhoto(
      String userId, ImageSource source, String title) async {
    isLoading.add(true);
    try {
      File imageFile = await pickImage(source);
      if (imageFile == null) throw DoNothingError();
      File croppedImageFile =
      await cropImage(imageFile, title);
      if (croppedImageFile == null) throw DoNothingError();

      List<int> imageBytes = croppedImageFile.readAsBytesSync();
      String base64ImageData = base64Encode(imageBytes);

      photo.add(base64ImageData);
    } catch (error, stacktrace) {
      log.info('PICK PHOTO $error');
      log.info(stacktrace);
      photo.addError(error);
    } finally {
      isLoading.add(false);
    }
  }

  Future<File> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source, maxWidth: 720);
    File file;
    if (pickedFile != null) {
      file = File(pickedFile.path);
    }
    return file;
  }
  Future<File> cropImage(File imageFile, String title,
      {double ratioX = 1, double ratioY = 1, int maxWidth = 520}) {
    return ImageCropper.cropImage(
      sourcePath: imageFile.path,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: title,
        toolbarColor: Colors.black,
        toolbarWidgetColor: Colors.white,
      ),
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
      maxWidth: maxWidth,
      maxHeight: (maxWidth * ratioY / ratioX).round(),
    );
  }
  void dispose() {
    createUpdate.close();
    photo.close();
    isLoading.close();
    isEmpty.close();
  }
}

class DoNothingError {}
