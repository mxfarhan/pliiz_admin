class QrCodeModel {
  final String title;
  final String userId;
  final String location;
  final String userName;
  final String industry;
  final String qrCodeId;
  final String type;
  final List<dynamic> hola;
  final List<dynamic> empId;
  final List<dynamic> companyId;

  QrCodeModel({
    required this.userName,
    required this.userId,
    required this.title,
    required this.industry,
    required this.location,
    required this.qrCodeId,
    required this.type,
    required this.hola,
    required this.empId,
    required this.companyId,
  });

  factory QrCodeModel.fromJson({required Map<String, dynamic> json, required String id}) {
    return QrCodeModel(
      userName: json["userName"] ?? "",
      userId: json["userId"] ?? "",
      title: json["title"] ?? "",
      industry: json["industry"] ?? "",
      location: json["location"] ?? "",
      qrCodeId: json["qrCodeId"] ?? id, // Fallback to document ID if not provided
      type: json["type"] ?? "NFC", // Default type to "NFC" if not present
      hola: (json["hola"] ?? []) is List ? json["hola"] : [],
      empId: (json["empId"] ?? []) is List ? json["empId"] : [],
      companyId: (json["companyId"] ?? []) is List ? json["companyId"] : [],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userName': userName,
    'userId': userId,
    'title': title,
    'industry': industry,
    'location': location,
    'qrCodeId': qrCodeId,
    'type': type,
    "hola": hola,
    "empId": empId,
    "companyId": companyId,
  };
}
