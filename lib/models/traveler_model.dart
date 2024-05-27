class TravelerModel {
  final String name, email, role;

  TravelerModel.fromJson(Map<String, dynamic> json)
      : name = json['nickname'],
        email = json['username'],
        role = json['role'];
}
