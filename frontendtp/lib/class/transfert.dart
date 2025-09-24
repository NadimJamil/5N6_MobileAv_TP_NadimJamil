
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfert.g.dart';

@JsonSerializable()
class RequeteAjoutTache {
  String nom = "";

  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime dateLimite = DateTime.now();

  RequeteAjoutTache(this.nom, this.dateLimite);

  factory RequeteAjoutTache.fromJson(Map<String, dynamic> json) => _$RequeteAjoutTacheFromJson(json);
  Map<String, dynamic> toJson() => _$RequeteAjoutTacheToJson(this);
}

final _dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

DateTime _fromJson(String date) => _dateFormatter.parse(date);
String _toJson(DateTime date) => _dateFormatter.format(date);