class ProductEditModel {
  int? slnum;
  String? comcod;
  String? invno;
  String? invcode;
  String? rsircode;
  String? reptsl;
  String? sirdesc;
  double? invqty;
  String? sirunit;
  String? sirunit2;
  double? siruconf;
  double? itmrat;
  double? itmam;
  double? idisam;
  double? idisam2;
  double? inetam;
  double? ivatam;
  String? invrmrk;
  String? batchref1;
  String? batchref2;
  String? batchref3;
  String? batchref4;
  String? batchrmrk;

  ProductEditModel(
      {this.slnum,
      this.comcod,
      this.invno,
      this.invcode,
      this.rsircode,
      this.reptsl,
      this.sirdesc,
      this.invqty,
      this.sirunit,
      this.sirunit2,
      this.siruconf,
      this.itmrat,
      this.itmam,
      this.idisam,
      this.idisam2,
      this.inetam,
      this.ivatam,
      this.invrmrk,
      this.batchref1,
      this.batchref2,
      this.batchref3,
      this.batchref4,
      this.batchrmrk});

  ProductEditModel.fromJson(Map<String, dynamic> json) {
    slnum = json['slnum'];
    comcod = json['comcod'];
    invno = json['invno'];
    invcode = json['invcode'];
    rsircode = json['rsircode'];
    reptsl = json['reptsl'];
    sirdesc = json['sirdesc'];
    invqty = json['invqty'];
    sirunit = json['sirunit'];
    sirunit2 = json['sirunit2'];
    siruconf = json['siruconf'];
    itmrat = json['itmrat'];
    itmam = json['itmam'];
    idisam = json['idisam'];
    idisam2 = json['idisam2'];
    inetam = json['inetam'];
    ivatam = json['ivatam'];
    invrmrk = json['invrmrk'];
    batchref1 = json['batchref1'];
    batchref2 = json['batchref2'];
    batchref3 = json['batchref3'];
    batchref4 = json['batchref4'];
    batchrmrk = json['batchrmrk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slnum'] = this.slnum;
    data['comcod'] = this.comcod;
    data['invno'] = this.invno;
    data['invcode'] = this.invcode;
    data['rsircode'] = this.rsircode;
    data['reptsl'] = this.reptsl;
    data['sirdesc'] = this.sirdesc;
    data['invqty'] = this.invqty;
    data['sirunit'] = this.sirunit;
    data['sirunit2'] = this.sirunit2;
    data['siruconf'] = this.siruconf;
    data['itmrat'] = this.itmrat;
    data['itmam'] = this.itmam;
    data['idisam'] = this.idisam;
    data['idisam2'] = this.idisam2;
    data['inetam'] = this.inetam;
    data['ivatam'] = this.ivatam;
    data['invrmrk'] = this.invrmrk;
    data['batchref1'] = this.batchref1;
    data['batchref2'] = this.batchref2;
    data['batchref3'] = this.batchref3;
    data['batchref4'] = this.batchref4;
    data['batchrmrk'] = this.batchrmrk;
    return data;
  }
}
