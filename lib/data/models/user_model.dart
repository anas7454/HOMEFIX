class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? avatar;
  final String role; // 'customer' or 'worker'
  final bool isProfileCompleted;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.avatar,
    this.role = 'customer',
    this.isProfileCompleted = false,
  });

  bool get isCustomer => role == 'customer';
  bool get isWorker => role == 'worker';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['full_name'] ?? json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar_url'] ?? json['avatar'],
      role: json['role'] ?? 'customer',
      isProfileCompleted: json['is_profile_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatar,
      'role': role,
      'is_profile_completed': isProfileCompleted,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatar,
    String? role,
    bool? isProfileCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      isProfileCompleted: isProfileCompleted ?? this.isProfileCompleted,
    );
  }
}
