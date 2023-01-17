import 'package:json_annotation/json_annotation.dart';

part 'api_exception.g.dart';

@JsonSerializable()
class YFApiException {
  final String text;
  final String localizedText;
  final String type;

  YFApiException(this.text, this.localizedText, this.type);

  YFApiException.fromText(this.text)
      : localizedText = text,
        type = 'UNKNOWN';

  factory YFApiException.fromJson(Map<String, dynamic> json) =>
      _$YFApiExceptionFromJson(json);

  Map<String, dynamic> toJson() => _$YFApiExceptionToJson(this);

  @override
  String toString() => 'API Exception: $localizedText';
}
