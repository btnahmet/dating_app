class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? token;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.token,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      token: token ?? this.token,
    );
  }
} 