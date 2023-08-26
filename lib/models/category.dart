class Category {
  final String id, imageUrl, title;

  Category({
    required this.id,
    required this.imageUrl,
    required this.title,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      imageUrl: json['imageUrl'],
      title: json['title'],
    );
  }
}
