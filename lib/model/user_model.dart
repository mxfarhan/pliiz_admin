class UserModel {
  String companyName;
  String contactName;
  String address;
  String city;
  String country;
  String email;
  String phone;
  bool isActive;
  int? noOfEmployees;
  int? noOfQRCodes;
  dynamic createdAt;

  UserModel({
    required this.companyName,
    required this.contactName,
    required this.address,
    required this.city,
    required this.country,
    required this.email,
    required this.phone,
    this.noOfEmployees,
    this.noOfQRCodes,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toMap(UserModel user) {
    var data = <String, dynamic>{};
    data["companyName"] = user.companyName;
    data["contactName"] = user.contactName;
    data["address"] = user.address;
    data["city"] = user.city;
    data["country"] = user.country;
    data["email"] = user.email;
    data["phone"] = user.phone;
    data["isActive"] = user.isActive;
    data["noOfEmployees"] = user.noOfEmployees;
    data["noOfQRCodes"] = user.noOfQRCodes;
    data["createdAt"] = user.createdAt;
    return data;
  }

  factory UserModel.fromSnapshot(Map<String, dynamic> data) {
    return UserModel(
      companyName: data["companyName"] ?? "",
      contactName: data["contactName"] ?? "",
      address: data["address"] ?? "",
      city: data["city"] ?? "",
      country: data["country"] ?? "",
      email: data["email"] ?? "",
      phone: data["phone"] ?? "",
      noOfEmployees: data["noOfEmployees"] is String
          ? int.tryParse(data["noOfEmployees"]) // Handle case where it's a String
          : data["noOfEmployees"], // Handle when it's an int or null
      noOfQRCodes: data["noOfQRCodes"] is String
          ? int.tryParse(data["noOfQRCodes"]) // Handle case where it's a String
          : data["noOfQRCodes"], // Handle when it's an int or null
      isActive: data["isActive"] is bool
          ? data["isActive"]
          : (data["isActive"] == "true" || data["isActive"] == 1), // Safely convert to bool
      createdAt: data["createdAt"] ?? "",
    );
  }
}
