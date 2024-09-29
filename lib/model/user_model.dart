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

  UserModel(
      {required this.companyName,
      required this.contactName,
      required this.address,
      required this.city,
      required this.country,
      required this.email,
      required this.phone,
      this.noOfEmployees,
      this.noOfQRCodes,
      required this.isActive,
      required this.createdAt});

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
      noOfEmployees: data["noOfEmployees"] ?? "",
      noOfQRCodes: data["noOfQRCodes"] ?? "",
      isActive: data["isActive"] ?? "",
      createdAt: data["createdAt"] ?? "",
    );
  }
}
