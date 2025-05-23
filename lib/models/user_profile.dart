class UserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? birthDate;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.birthDate,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      birthDate: json['birth_date'],
    );
  }
}