// ignore_for_file: public_member_api_docs, sort_constructors_first
class Profile {
  final String id;
  final String firstName;
  final String lastName;

  Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
String get display => "$firstName $lastName";

  factory Profile.fromMap(Map<String, dynamic> map) {
    
    return Profile(
      id: map['id'] as String,
      firstName: map['first_name'] as String,
      lastName: map['last_name'] as String,
    );
  }

  static final cache = <String, Profile>{};
}
