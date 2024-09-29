class AssignModel{
  final String id;
  final String wId;
  final String qrTitle;
  final String qrId;
  final String qrLocation;
  final String qrType;
  final String qrHola;
  final String cId;
  final String cTitle;
  final dynamic stamp;
  final String employeeName;
  final String employeeId;
  final String employeeImage;
  final String companyId;
  final String createdAt;
  final String token;
  final bool finalCall;
  AssignModel({
    required this.id,
    required this.wId,
    required this.qrTitle,
    required this.qrId,
    required this.qrLocation,
    required this.qrType,
    required this.qrHola,
    required this.cId,
    required this.cTitle,
    required this.stamp,
    required this.employeeName,
    required this.employeeId,
    required this.employeeImage,
    required this.companyId,
    required this.createdAt,
    required this.finalCall,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'wId': wId,
      'qrTitle': qrTitle,
      'qrId': qrId,
      'qrLocation': qrLocation,
      'qrType': qrType,
      'qrHola': qrHola,
      'cId': cId,
      'cTitle': cTitle,
      'stamp': stamp,
      'employeeName': employeeName,
      'employeeId': employeeId,
      'employeeImage': employeeImage,
      'companyId': companyId,
      "createdAt": createdAt,
      "finalCall": finalCall,
      "token": token,
    };
  }

  factory AssignModel.fromMap(Map<String, dynamic> map, {id = ""}) {
    return AssignModel(
      id: id,
      wId: map['wId'] as String,
      qrTitle: map['qrTitle'] as String,
      qrId: map['qrId'] as String,
      qrLocation: map['qrLocation'] as String,
      qrType: map['qrType'] as String,
      qrHola: map['qrHola'] as String,
      cId: map['cId'] as String,
      cTitle: map['cTitle'] as String,
      stamp: map['stamp'] as dynamic,
      employeeName: map['employeeName'] as String,
      employeeId: map['employeeId'] as String,
      employeeImage: map['employeeImage'] as String,
      companyId: map['companyId'] as String,
      createdAt: map["createdAt"] as String,
      finalCall: map["finalCall"],
      token: map["token"]??"",
    );
  }
}