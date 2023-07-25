class BranchModel {
  String? comcod;
  String? sectcod;
  String? sectname;
  String? sectdesc;
  int? rowid;

  BranchModel(
      {this.comcod, this.sectcod, this.sectname, this.sectdesc, this.rowid});

  BranchModel.fromJson(Map<String, dynamic> json) {
    comcod = json['comcod'];
    sectcod = json['sectcod'];
    sectname = json['sectname'];
    sectdesc = json['sectdesc'];
    rowid = json['rowid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comcod'] = this.comcod;
    data['sectcod'] = this.sectcod;
    data['sectname'] = this.sectname;
    data['sectdesc'] = this.sectdesc;
    data['rowid'] = this.rowid;
    return data;
  }
}