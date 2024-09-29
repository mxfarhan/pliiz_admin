class LogoModel{
  final String url;
  final dynamic createdAt;
  final dynamic updatedAt;
  final String companyId;
  final String text;
  LogoModel({required this.url,required this.createdAt,required this.updatedAt,required this.companyId,this.text=""});
  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'companyId': companyId,
      "text": text,
    };
  }
  factory LogoModel.fromMap(Map<String, dynamic> map) {
    return LogoModel(
      url: map['url'] as String,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      companyId: map['companyId'] as String,
      text: map['text']??""
    );
  }
}