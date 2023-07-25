class CustomerCategoryModel {
  String? comcod;
  String? sircode;
  String? sirdesc;
  String? sirtype;
  String? sirtdes;
  String? sirunit;
  String? sirunit2;
  String? sirunit3;
  double? siruconf;
  double? siruconf3;
  int? rowid;
  String? rowtime;
  String? sircode1;
  String? sirdesc1;

  CustomerCategoryModel(
      {this.comcod,
      this.sircode,
      this.sirdesc,
      this.sirtype,
      this.sirtdes,
      this.sirunit,
      this.sirunit2,
      this.sirunit3,
      this.siruconf,
      this.siruconf3,
      this.rowid,
      this.rowtime,
      this.sircode1,
      this.sirdesc1});

  CustomerCategoryModel.fromJson(Map<String, dynamic> json) {
    comcod = json['comcod'];
    sircode = json['sircode'];
    sirdesc = json['sirdesc'];
    sirtype = json['sirtype'];
    sirtdes = json['sirtdes'];
    sirunit = json['sirunit'];
    sirunit2 = json['sirunit2'];
    sirunit3 = json['sirunit3'];
    siruconf = json['siruconf'];
    siruconf3 = json['siruconf3'];
    rowid = json['rowid'];
    rowtime = json['rowtime'];
    sircode1 = json['sircode1'];
    sirdesc1 = json['sirdesc1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comcod'] = this.comcod;
    data['sircode'] = this.sircode;
    data['sirdesc'] = this.sirdesc;
    data['sirtype'] = this.sirtype;
    data['sirtdes'] = this.sirtdes;
    data['sirunit'] = this.sirunit;
    data['sirunit2'] = this.sirunit2;
    data['sirunit3'] = this.sirunit3;
    data['siruconf'] = this.siruconf;
    data['siruconf3'] = this.siruconf3;
    data['rowid'] = this.rowid;
    data['rowtime'] = this.rowtime;
    data['sircode1'] = this.sircode1;
    data['sirdesc1'] = this.sirdesc1;
    return data;
  }
}
