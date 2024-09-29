class EmployeesModel{
  String id;
  String name;
  String photoUrl;
  String companyName;
  String companyId;
  List locations;

  EmployeesModel({
    required this.id,
    required this.name,
    required this.companyName,
    required this.locations,
    required this.photoUrl,
    required this.companyId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'companyName': companyName,
      'companyId': companyId,
      'locations': locations,
    };
  }

  factory EmployeesModel.fromMap(Map<String, dynamic> map,String id) {
    return EmployeesModel(
      id: id,
      name: map['name']??"",
      photoUrl: map['photoUrl']??"",
      companyName: map['companyName']??"",
      companyId: map['companyId']??"",
      locations: map['locations'] as List,
    );
  }
}