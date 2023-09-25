import 'package:json_annotation/json_annotation.dart';
import 'package:uaexpense/transactions.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse{
  String balance;
  @JsonKey(name: 'transactions')
  List<Transactions> transactionsList;
  TransactionResponse({required this.balance, required this.transactionsList});

  // Comment these before running the $ flutter pub run build_runner build
    factory TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);
    Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);

}