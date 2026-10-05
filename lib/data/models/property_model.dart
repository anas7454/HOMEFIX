class PropertyModel {
  final String id;
  final String title;
  final String address;
  final double price;
  final String? imageUrl;

  PropertyModel({
    required this.id,
    required this.title,
    required this.address,
    required this.price,
    this.imageUrl,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'address': address,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
