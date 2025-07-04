import 'package:carma/features/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  final String id;
  final String? name;
  final String email;

  ProfileModel({
    required this.id,
    this.name,
    required this.email,
  }) : super(
          id: id,
          name: name,
          email: email,
        );
}
