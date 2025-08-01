// class MovieModel {
//   final String name;
//   final String description;
//   final String imageUrl;

//   MovieModel({
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//   });

//   factory MovieModel.fromJson(Map<String, dynamic> json) {
//     return MovieModel(
//       name: json['title'] ?? 'No title',
//       description: json['overview'] ?? 'No description',
//       imageUrl: json['poster_path'] != null
//           ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
//           : '',
//     );
//   }
// }
class MovieModel {
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  MovieModel({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? json['_id'] ?? '',
      title: json['Title'] ?? json['title'] ?? 'İsimsiz',
      description: json['Plot'] ?? json['description'] ?? 'Açıklama yok',
      posterUrl: (json['Poster'] ?? json['posterUrl'] ?? '').replaceFirst('http://', 'https://'),
    );
  }
}
