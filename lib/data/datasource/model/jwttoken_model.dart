class JwtTokenModel {
  bool? istokenstr;
  String? tokenstr;
  String? createtime;
  String? expirytime;
  String? tokenmsg;
  String? hccode;
  String? hcname;
  String? sessionid;
  String? designation;

  JwtTokenModel(
      {this.istokenstr,
      this.tokenstr,
      this.createtime,
      this.expirytime,
      this.tokenmsg,
      this.hccode,
      this.hcname,
      this.sessionid,
      this.designation});

  JwtTokenModel.fromJson(Map<String, dynamic> json) {
    istokenstr = json['istokenstr'];
    tokenstr = json['tokenstr'];
    createtime = json['createtime'];
    expirytime = json['expirytime'];
    tokenmsg = json['tokenmsg'];
    hccode = json['hccode'];
    hcname = json['hcname'];
    sessionid = json['sessionid'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['istokenstr'] = this.istokenstr;
    data['tokenstr'] = this.tokenstr;
    data['createtime'] = this.createtime;
    data['expirytime'] = this.expirytime;
    data['tokenmsg'] = this.tokenmsg;
    data['hccode'] = this.hccode;
    data['hcname'] = this.hcname;
    data['sessionid'] = this.sessionid;
    data['designation'] = this.designation;
    return data;
  }
}
