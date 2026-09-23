class CustomerModel {
  final String? uid;
  final String? phoneNumber;
  final String? name;
  final String? email;
  final String? address;
  final String? password;

  CustomerModel({
    this.uid,
    this.phoneNumber,
    this.name,
    this.email,
    this.address,
    this.password,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      password: map['password'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'address': address,
      'password': password,
    };
  }

  CustomerModel copyWith({
    String? uid,
    String? phoneNumber,
    String? name,
    String? email,
    String? address,
    String? password,
  }) {
    return CustomerModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      password: password ?? this.password,
    );
  }
}
