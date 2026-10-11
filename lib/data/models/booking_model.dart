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
      id: json['id']?.toString() ?? '',
      serviceName: (json['service'] is Map)
          ? (json['service']['title'] ?? 'HomeFix Service')
          : (json['serviceName'] ?? 'HomeFix Service'),
      status: json['status'] ?? 'pending',
      bookingDate: json['booking_date'] != null
          ? (DateTime.tryParse(json['booking_date'].toString()) ?? DateTime.now())
          : (json['bookingDate'] != null
              ? (DateTime.tryParse(json['bookingDate'].toString()) ?? DateTime.now())
              : DateTime.now()),
      price: (json['total_amount'] ?? json['price'] ?? 0).toDouble(),
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
