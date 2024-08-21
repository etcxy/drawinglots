@Deprecated('序列化原因，弃用，改用UserEntity')
class UserStruct2 {
  String _userID; //学生学号
  String _userName; //学生姓名
  Set<String> _userTags;
  int? weight; //权重

  //构造函数语法糖，为属性赋值
  UserStruct2(this._userID, this._userName, this._userTags, {this.weight = 50});

  //toString方法重写
  @override
  String toString() {
    return 'UserStruct2{_userID: $_userID, _userName: $_userName,_userTags: $_userTags}';
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  Set<String> get userTags => _userTags;

  set userTags(Set<String> value) {
    _userTags = value;
  }

  ///序列化
  Map<String, dynamic> toJson() {
    return {
      'userID': _userID,
      'userName': _userName,
      'userTags': _userTags,
    };
  }

  ///反序列化
  factory UserStruct2.fromJson(Map<String, dynamic> json) {
    return UserStruct2(
      json['userID'] as String,
      json['userName'] as String,
      json['userTags'] as Set<String>,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStruct2 &&
          runtimeType == other.runtimeType &&
          _userID == other._userID;

  @override
  int get hashCode =>
      _userTags.hashCode ^ _userID.hashCode ^ _userName.hashCode;
}
