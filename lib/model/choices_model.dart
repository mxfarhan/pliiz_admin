class ChoicesModel{
  final String id;
  final String title;
  final bool isFile;
  final bool isText;
  final String dialogMessage;
  String messageAfterConform;
  final String companyName;
  final String userId;
  final String userName;
  final String fileName;
  final bool isUrl;
  ChoicesModel({
    required this.id,
    required this.title,
    required this.isFile,
    required this.isText,
    required this.dialogMessage,
    required this.companyName,
    required this.userId,
    required this.userName,
    required this.fileName,
    required this.messageAfterConform,
    this.isUrl = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'title': title,
      'isFile': isFile,
      'isText': isText,
      'dialogMessage': dialogMessage,
      'companyName': companyName,
      'userId': userId,
      'userName': userName,
      "fileName": fileName,
      "messageAfterConform": messageAfterConform,
      "isUrl": isUrl,
    };
  }

  factory ChoicesModel.fromMap({required Map<String, dynamic> map, required String id}) {
    return ChoicesModel(
      id: id,
      title: map['title'] as String,
      isFile: map['isFile'] as bool,
      isText: map['isText'] as bool,
      dialogMessage: map['dialogMessage'] as String,
      companyName: map['companyName'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      fileName: map['fileName'] as String,
      messageAfterConform: map["messageAfterConform"],
      isUrl:  map["isUrl"]??false,
    );
  }
}