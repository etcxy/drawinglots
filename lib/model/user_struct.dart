class UserStruct {
  String _userGroup; //学生组别
  String _userID; //学生学号
  String _userName; //学生姓名
  int? weight; //权重

  //构造函数语法糖，为属性赋值
  UserStruct(this._userGroup, this._userID, this._userName, {this.weight = 50});

  // UserStruct({this._userGroup, this._userID, this._userName});

  //toString方法重写
  @override
  String toString() {
    return 'UserStruct{_userGroup: $_userGroup, _userID: $_userID, _userName: $_userName}';
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get userGroup => _userGroup;

  set userGroup(String value) {
    _userGroup = value;
  }

  ///序列化
  Map<String, dynamic> toJson() {
    return {
      'userGroup': _userGroup,
      'userID': _userID,
      'userName': _userName,
    };
  }

  ///反序列化
  factory UserStruct.fromJson(Map<String, dynamic> json) {
    return UserStruct(
      json['userGroup'],
      json['userID'],
      json['userName'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStruct &&
          runtimeType == other.runtimeType &&
          _userGroup == other._userGroup &&
          _userID == other._userID &&
          _userName == other._userName;

  @override
  int get hashCode =>
      _userGroup.hashCode ^ _userID.hashCode ^ _userName.hashCode;
}
