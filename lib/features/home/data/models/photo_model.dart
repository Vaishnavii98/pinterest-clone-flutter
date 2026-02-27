class PhotoModel {
  final String id;
  final String imageUrl;
  final String photographer;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.photographer,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'].toString(),
      imageUrl: json['src']['large'],
      photographer: json['photographer'] ?? 'Unknown',
    );
  }
}