import 'package:flutter/material.dart';
import '../../../home/data/models/photo_model.dart';
import '../../../home/data/services/pexels_service.dart';

class SearchProvider extends ChangeNotifier {
  final PexelsService _service = PexelsService();

  List<PhotoModel> _results = [];
  List<PhotoModel> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> search(String query) async {
    if (query.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      _results = await _service.searchPhotos(query);
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}