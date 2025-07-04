import 'package:carma/features/google_sign_in/domain/entities/signed_in_user_entity.dart';

class SignedInUserModel extends SignedInUserEntity {
  final String id;
  final String? name;
  final String email;

  SignedInUserModel({required this.id, required this.name, required this.email})
      : super(id: id, name: name, email: email);
}
