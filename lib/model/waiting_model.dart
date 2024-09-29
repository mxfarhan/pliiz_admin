class WaitingModel{
  final String wId;
  final String qrTitle;
  final String qrId;
  final String qrLocation;
  final String qrType;
  final List qrHola;
  final String cId;
  final String cTitle;
  final dynamic stamp;
  final String companyId;
  final List empId;
  final String token;
  WaitingModel({
    required this.wId,
    required this.qrTitle,
    required this.qrId,
    required this.qrLocation,
    required this.qrType,
    required this.qrHola,
    required this.cId,
    required this.cTitle,
    required this.stamp,
    required this.companyId,
    required this.empId,
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
      "stamp": stamp,
      "companyId": companyId,
      "empId": empId,
      "token": token,
    };
  }

  factory WaitingModel.fromMap({required Map<String, dynamic> map,required String id}) {
    return WaitingModel(
        wId: id,
        qrTitle: map['qrTitle'] as String,
        qrId: map['qrId'] as String,
        qrLocation: map['qrLocation'] as String,
        qrType: map['qrType'] as String,
        qrHola: map['qrHola'],
        cId: map['cId'] as String,
        cTitle: map['cTitle'] as String,
        stamp: map['stamp'],
        companyId: map['companyId'],
        empId: map['empId'],
        token: map["token"]??""
    );
  }
}