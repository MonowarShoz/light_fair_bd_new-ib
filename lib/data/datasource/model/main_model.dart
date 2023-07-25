class MainModel {
  List<RateSaleItem>? table;
  List<Table1>? table1;
  List<Table2>? table2;
  List<Table3>? table3;

  MainModel({this.table, this.table1, this.table2, this.table3});

  MainModel.fromJson(Map<String, dynamic> json) {
    if (json['Table'] != null) {
      table = <RateSaleItem>[];
      json['Table'].forEach((v) {
        table!.add(new RateSaleItem.fromJson(v));
      });
    }
    if (json['Table1'] != null) {
      table1 = <Table1>[];
      json['Table1'].forEach((v) {
        table1!.add(new Table1.fromJson(v));
      });
    }
    if (json['Table2'] != null) {
      table2 = <Table2>[];
      json['Table2'].forEach((v) {
        table2!.add(new Table2.fromJson(v));
      });
    }
    if (json['Table3'] != null) {
      table3 = <Table3>[];
      json['Table3'].forEach((v) {
        table3!.add(new Table3.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.table != null) {
      data['Table'] = this.table!.map((v) => v.toJson()).toList();
    }
    if (this.table1 != null) {
      data['Table1'] = this.table1!.map((v) => v.toJson()).toList();
    }
    if (this.table2 != null) {
      data['Table2'] = this.table2!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateSaleItem {
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

  RateSaleItem(
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

  RateSaleItem.fromJson(Map<String, dynamic> json) {
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

class Table1 {
  String? msircode;
  String? msirdesc;
  String? msirtype;

  Table1({this.msircode, this.msirdesc, this.msirtype});

  Table1.fromJson(Map<String, dynamic> json) {
    msircode = json['msircode'];
    msirdesc = json['msirdesc'];
    msirtype = json['msirtype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msircode'] = this.msircode;
    data['msirdesc'] = this.msirdesc;
    data['msirtype'] = this.msirtype;
    return data;
  }
}

class Table2 {
  String? msirtype;

  Table2({this.msirtype});

  Table2.fromJson(Map<String, dynamic> json) {
    msirtype = json['msirtype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msirtype'] = this.msirtype;
    return data;
  }
}

class Table3 {
  String? serverTime;

  Table3({this.serverTime});

  Table3.fromJson(Map<String, dynamic> json) {
    serverTime = json['ServerTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ServerTime'] = this.serverTime;
    return data;
  }
}
