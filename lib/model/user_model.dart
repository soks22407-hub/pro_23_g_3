class UserModel {
  int? id;
  String? username;
  String? nickName;
  bool? enabled;
  String? imageName;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;

  UserModel({
    this.id,
    this.username,
    this.nickName,
    this.enabled,
    this.imageName,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    username: json['username'],
    nickName: json['nickName'],
    enabled: json['enabled'],
    imageName: json['imageName'],
    imageUrl: json['imageUrl'],
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'nickName': nickName,
    'enabled': enabled,
    'imageName': imageName,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}