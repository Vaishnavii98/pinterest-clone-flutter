class PhotoModel {
  final String id;
  final String imageUrl;
  final String photographer;
  final String alt;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.photographer,
    required this.alt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'].toString(),
      imageUrl: json['src']['large'],
      photographer: json['photographer'] ?? 'Unknown',
      alt: json['alt'] ?? '',
    );
  }
}