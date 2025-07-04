class ProfileEntity {
  final String id;
  final String? name;
  final String email;

  ProfileEntity({
    required this.id,
    this.name,
    required this.email,
  });
}
