import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable()
class YFUserInfo {
  final String firstname;
  final String lastname;
  final String picture;
  final String locale;

  YFUserInfo({
    this.firstname = '',
    this.lastname = '',
    this.picture = '',
    this.locale = '',
  });

  factory YFUserInfo.fromJson(Map<String, dynamic> json) =>
      _$YFUserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$YFUserInfoToJson(this);
}
