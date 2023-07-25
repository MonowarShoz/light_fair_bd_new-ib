class User {
  String? userId;
  String? password;
  String? terminalID;
  int? expirhour;

  User({this.userId, this.password,this.terminalID, this.expirhour});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    expirhour = json['expirhour'];
    terminalID = json['terminalID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['password'] = this.password;
    data['terminalID'] = this.terminalID;
    data['expirhour'] = this.expirhour;
    return data;
  }
}
