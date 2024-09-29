class QueryModel{
  final String salesName;
  final int days;
  QueryModel({required this.salesName,required this.days});
}

List<QueryModel> salesList = [
  QueryModel(salesName: "Today's", days: 1),
  QueryModel(salesName: "Weekly", days: 7),
  QueryModel(salesName: "Monthly", days: 30),
];