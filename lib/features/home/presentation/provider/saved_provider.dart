import 'package:flutter/material.dart';
import '../../../home/data/models/photo_model.dart';

class SavedProvider extends ChangeNotifier {
  final List<PhotoModel> _savedPins = [];

  List<PhotoModel> get savedPins => _savedPins;

  bool isSaved(PhotoModel photo) {
    return _savedPins.any((p) => p.id == photo.id);
  }

  void toggleSave(PhotoModel photo) {
    if (isSaved(photo)) {
      _savedPins.removeWhere((p) => p.id == photo.id);
    } else {
      _savedPins.add(photo);
    }
    notifyListeners();
  }
}