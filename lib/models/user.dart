import 'dart:io';

class UsersData {
  String email;

  String name;

  String userID;

  String profilePictureURL;

  String appIdentifier;

  UsersData(
      {this.email = '',
      this.name = '',
      this.userID = '',
      this.profilePictureURL = ''})
      : this.appIdentifier = 'Flutter Login Screen ${Platform.operatingSystem}';

  factory UsersData.fromJson(Map<String, dynamic> parsedJson) {
    return UsersData(
        email: parsedJson['email'] ?? '',
        name: parsedJson['name'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'id': userID,
      'profilePictureURL': profilePictureURL,
      'appIdentifier': appIdentifier
    };
  }
}
