import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity {
  String userID;

  String userName;

  Set<String> userTags;

  int weight;

  UserEntity(this.userID, this.userName, this.userTags, {this.weight = 50});

  factory UserEntity.fromJson(Map<String, dynamic> srcJson) =>
      _$UserEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);

  @override
  String toString() {
    return 'UserEntity{userID: $userID, userName: $userName, userTags: $userTags}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          userID == other.userID;

  @override
  int get hashCode => userID.hashCode;
}
