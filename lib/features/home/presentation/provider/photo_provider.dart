import 'package:flutter/material.dart';
import '../../data/models/photo_model.dart';
import '../../data/services/pexels_service.dart';

class PhotoProvider extends ChangeNotifier {
  final PexelsService _service = PexelsService();

  final List<PhotoModel> _photos = [];
  List<PhotoModel> get photos => _photos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 1;
  bool _hasMore = true;

  Future<void> fetchInitialPhotos() async {
    _page = 1;
    _hasMore = true;
    _photos.clear();
    await fetchMorePhotos();
  }

  Future<void> fetchMorePhotos() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPhotos = await _service.fetchPhotos(page: _page);

      if (newPhotos.isEmpty) {
        _hasMore = false;
      } else {
        _photos.addAll(newPhotos);
        _page++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshPhotos() async {
    await fetchInitialPhotos();
  }
}