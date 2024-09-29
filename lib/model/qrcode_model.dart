class QrCodeModel{
  final String title;
  final String userId;
  final String location;
  final String userName;
  final String industry;
  final String qrCodeId;
  final String type;
  final List hola;
  final List empId;
  final List companyId;
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
  factory QrCodeModel.fromJson({required Map<String, dynamic> json, required String id}){
    return QrCodeModel(
      userName: json["userName"],
      userId: json["userId"],
      title: json["title"],
      industry: json["industry"],
      location: json["location"],
      qrCodeId: json["qrCodeId"],
      type: json["type"],
      hola: json["hola"],
      empId: json["empId"],
        companyId: json["companyId"],
    );
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
    'userName': userName,
    'userId': userId,
    'title': title,
    'industry': industry,
    'location': location,
    'qrCodeId': qrCodeId,
    'type': "NFC",
    "hola": hola,
    "empId": empId,
    "companyId":userId,

  };
}