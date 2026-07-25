import 'package:freezed_annotation/freezed_annotation.dart';

part 'line.freezed.dart';
part 'line.g.dart';

@freezed
class Line with _$Line {
  const factory Line({
    required String id,
    required String plantId,
    required String name,
    required bool active,
  }) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
}
