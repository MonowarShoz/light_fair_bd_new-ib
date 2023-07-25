class AppUserListModel {
  String? slnum;
  String? hccode;
  String? signinnam;
  String? namedsg;
  String? userrmrk;
  String? hcpass;

  AppUserListModel(
      {this.slnum,
      this.hccode,
      this.signinnam,
      this.namedsg,
      this.userrmrk,
      this.hcpass});

  AppUserListModel.fromJson(Map<String, dynamic> json) {
    slnum = json['slnum'];
    hccode = json['hccode'];
    signinnam = json['signinnam'];
    namedsg = json['namedsg'];
    userrmrk = json['userrmrk'];
    hcpass = json['hcpass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slnum'] = this.slnum;
    data['hccode'] = this.hccode;
    data['signinnam'] = this.signinnam;
    data['namedsg'] = this.namedsg;
    data['userrmrk'] = this.userrmrk;
    data['hcpass'] = this.hcpass;
    return data;
  }
}