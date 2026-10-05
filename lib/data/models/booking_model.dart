class BookingModel {
  final String id;
  final String serviceName;
  final String status;
  final DateTime bookingDate;
  final double price;

  BookingModel({
    required this.id,
    required this.serviceName,
    required this.status,
    required this.bookingDate,
    required this.price,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      status: json['status'] ?? 'pending',
      bookingDate: json['bookingDate'] != null
          ? DateTime.parse(json['bookingDate'])
          : DateTime.now(),
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'status': status,
      'bookingDate': bookingDate.toIso8601String(),
      'price': price,
    };
  }
}
