class News {
  final String id;
  final String title;
  final String description;
  final String url;
  final String author;
  final String image;
  final String language;
  final List<String> category;
  final String published;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.author,
    required this.image,
    required this.language,
    required this.category,
    required this.published,
  });

  // JSON verisinden News nesnesi oluşturan factory constructor
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? 'Açıklama yok', // Boş açıklamayı engellemek için varsayılan değer
      url: json['url'],
      author: json['author'] ?? 'Bilinmeyen Yazar', // Eğer yazar bilgisi yoksa varsayılan değer
      image: json['image'] ?? '', // Görsel yoksa boş bırakabiliriz
      language: json['language'],
      category: List<String>.from(json['category']), // Kategorileri List<String> olarak alıyoruz
      published: json['published'],
    );
  }

  // JSON verisine dönüştürme fonksiyonu
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'author': author,
      'image': image,
      'language': language,
      'category': category,
      'published': published,
    };
  }
}
