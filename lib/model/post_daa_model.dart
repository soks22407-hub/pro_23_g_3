import 'user_model.dart';

class PostDataModel {
  int? id;
  String? title;
  String? content;
  String? imageName;
  String? imageUrl;
  bool? published;
  UserModel? author;
  String? createdAt;
  String? updatedAt;

  PostDataModel({
    this.id,
    this.title,
    this.content,
    this.imageName,
    this.imageUrl,
    this.published,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  factory PostDataModel.fromJson(Map<String, dynamic> json) => PostDataModel(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    imageName: json['imageName'],
    imageUrl: json['imageUrl'],
    published: json['published'],
    author: json['author'] != null ? UserModel.fromJson(json['author']) : null,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'imageName': imageName,
    'imageUrl': imageUrl,
    'published': published,
    if (author != null) 'author': author!.toJson(),
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}