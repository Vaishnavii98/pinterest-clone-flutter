import 'package:dio/dio.dart';
import '../models/photo_model.dart';

class PexelsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.pexels.com/v1/',
      headers: {
        'Authorization': const String.fromEnvironment('PEXELS_API_KEY'),
      },
    ),
  );

  Future<List<PhotoModel>> fetchPhotos({int page = 1}) async {
    final response = await _dio.get(
      'curated',
      queryParameters: {
        'page': page,
        'per_page': 20,
      },
    );

    final List photosJson = response.data['photos'];

    return photosJson
        .map((json) => PhotoModel.fromJson(json))
        .toList();
  }
  Future<List<PhotoModel>> searchPhotos(String query, {int page = 1}) async {
  final response = await _dio.get(
    'search',
    queryParameters: {
      'query': query,
      'page': page,
      'per_page': 20,
    },
  );

  final List photosJson = response.data['photos'];

  return photosJson
      .map((json) => PhotoModel.fromJson(json))
      .toList();
}
}