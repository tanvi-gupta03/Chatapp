class Chatuser {
  Chatuser({
    required this.about,
    required this.lastActive,
    required this.name,
    required this.email,
    required this.createdAt,
  });
  late final String about;
  late final String lastActive;
  late final String name;
  late final String email;
  late final String createdAt;
  
  Chatuser.fromJson(Map<String, dynamic> json){
    about = json['about'];
    lastActive = json['last_active'];
    name = json['name'];
    email = json['email'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['email'] = email;
    data['created_at'] = createdAt;
    return data;
  }
}