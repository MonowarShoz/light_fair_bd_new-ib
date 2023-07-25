import 'package:flutter/cupertino.dart';

class RetItemSale with ChangeNotifier {
  String? comcod;
  String? invcode;
  String? sircode;
  String? batchno;
  String? sirdesc;
  double? costprice;
  double? saleprice;
  double? refscomp;
  double? salvatp;
  String? sirtype;
  String? sirunit;
  String? sirunit2;
  String? sirunit3;
  String? mfgdat;
  String? expdat;
  double? siruconf;
  double? siruconf3;
  String? msircode;
  String? msirdesc;
  String? mfgid;
  String? mfgcomcod;
  String? mfgcomnam;
  String? genrcod;
  String? genrnam;

  RetItemSale(
      {this.comcod,
      this.invcode,
      this.sircode,
      this.batchno,
      this.sirdesc,
      this.costprice,
      this.saleprice,
      this.refscomp,
      this.salvatp,
      this.sirtype,
      this.sirunit,
      this.sirunit2,
      this.sirunit3,
      this.mfgdat,
      this.expdat,
      this.siruconf,
      this.siruconf3,
      this.msircode,
      this.msirdesc,
      this.mfgid,
      this.mfgcomcod,
      this.mfgcomnam,
      this.genrcod,
      this.genrnam});

  RetItemSale.fromJson(Map<String, dynamic> json) {
    comcod = json['comcod'];
    invcode = json['invcode'];
    sircode = json['sircode'];
    batchno = json['batchno'];
    sirdesc = json['sirdesc'];
    costprice = json['costprice'];
    saleprice = json['saleprice'];
    refscomp = json['refscomp'];
    salvatp = json['salvatp'];
    sirtype = json['sirtype'];
    sirunit = json['sirunit'];
    sirunit2 = json['sirunit2'];
    sirunit3 = json['sirunit3'];
    mfgdat = json['mfgdat'];
    expdat = json['expdat'];
    siruconf = json['siruconf'];
    siruconf3 = json['siruconf3'];
    msircode = json['msircode'];
    msirdesc = json['msirdesc'];
    mfgid = json['mfgid'];
    mfgcomcod = json['mfgcomcod'];
    mfgcomnam = json['mfgcomnam'];
    genrcod = json['genrcod'];
    genrnam = json['genrnam'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comcod'] = this.comcod;
    data['invcode'] = this.invcode;
    data['sircode'] = this.sircode;
    data['batchno'] = this.batchno;
    data['sirdesc'] = this.sirdesc;
    data['costprice'] = this.costprice;
    data['saleprice'] = this.saleprice;
    data['refscomp'] = this.refscomp;
    data['salvatp'] = this.salvatp;
    data['sirtype'] = this.sirtype;
    data['sirunit'] = this.sirunit;
    data['sirunit2'] = this.sirunit2;
    data['sirunit3'] = this.sirunit3;
    data['mfgdat'] = this.mfgdat;
    data['expdat'] = this.expdat;
    data['siruconf'] = this.siruconf;
    data['siruconf3'] = this.siruconf3;
    data['msircode'] = this.msircode;
    data['msirdesc'] = this.msirdesc;
    data['mfgid'] = this.mfgid;
    data['mfgcomcod'] = this.mfgcomcod;
    data['mfgcomnam'] = this.mfgcomnam;
    data['genrcod'] = this.genrcod;
    data['genrnam'] = this.genrnam;
    return data;
  }
}
