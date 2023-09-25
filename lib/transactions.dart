import 'package:json_annotation/json_annotation.dart';

part 'transactions.g.dart';

@JsonSerializable()
class Transactions{
  String name;
  String type;
  double amount;

  Transactions({ required this.name, required this.type, required this.amount});

  // Comment these before running the $ flutter pub run build_runner build

  factory Transactions.fromJson(Map<String, dynamic> json) => _$TransactionsFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionsToJson(this);
}

