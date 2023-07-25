class OrderHistoryInfoModel {
  int? slnum;
  String? comcod;
  String? invno;
  String? invno1;
  String? refinv;
  String? refinv1;
  String? invdat;
  String? invdat1;
  String? invbyid;
  String? invbyName;
  String? sectcod;
  String? sectname;
  String? paytype;
  String? invref;
  String? invrefdat;
  String? custid;
  String? custName;
  String? placeid;
  String? placedes;
  String? delivartime;
  String? invnar;
  String? invstatus;
  String? poref;
  String? payterm;
  String? delplac;
  String? delbyid;
  String? delbyName;
  double? totqty;
  double? totslam;
  double? tdisam;
  double? netslam;
  double? tvatam;
  double? billam;
  double? collam;
  double? dueam;
  String? maxcoldat;
  String? maxcolid;
  String? prepareses;
  String? preparetrm;
  int? rowid;
  String? rowtime;

  OrderHistoryInfoModel(
      {this.slnum,
      this.comcod,
      this.invno,
      this.invno1,
      this.refinv,
      this.refinv1,
      this.invdat,
      this.invdat1,
      this.invbyid,
      this.invbyName,
      this.sectcod,
      this.sectname,
      this.paytype,
      this.invref,
      this.invrefdat,
      this.custid,
      this.custName,
      this.placeid,
      this.placedes,
      this.delivartime,
      this.invnar,
      this.invstatus,
      this.poref,
      this.payterm,
      this.delplac,
      this.delbyid,
      this.delbyName,
      this.totqty,
      this.totslam,
      this.tdisam,
      this.netslam,
      this.tvatam,
      this.billam,
      this.collam,
      this.dueam,
      this.maxcoldat,
      this.maxcolid,
      this.prepareses,
      this.preparetrm,
      this.rowid,
      this.rowtime});

  OrderHistoryInfoModel.fromJson(Map<String, dynamic> json) {
    slnum = json['slnum'];
    comcod = json['comcod'];
    invno = json['invno'];
    invno1 = json['invno1'];
    refinv = json['refinv'];
    refinv1 = json['refinv1'];
    invdat = json['invdat'];
    invdat1 = json['invdat1'];
    invbyid = json['invbyid'];
    invbyName = json['invbyName'];
    sectcod = json['sectcod'];
    sectname = json['sectname'];
    paytype = json['paytype'];
    invref = json['invref'];
    invrefdat = json['invrefdat'];
    custid = json['custid'];
    custName = json['custName'];
    placeid = json['placeid'];
    placedes = json['placedes'];
    delivartime = json['delivartime'];
    invnar = json['invnar'];
    invstatus = json['invstatus'];
    poref = json['poref'];
    payterm = json['payterm'];
    delplac = json['delplac'];
    delbyid = json['delbyid'];
    delbyName = json['delbyName'];
    totqty = json['totqty'];
    totslam = json['totslam'];
    tdisam = json['tdisam'];
    netslam = json['netslam'];
    tvatam = json['tvatam'];
    billam = json['billam'];
    collam = json['collam'];
    dueam = json['dueam'];
    maxcoldat = json['maxcoldat'];
    maxcolid = json['maxcolid'];
    prepareses = json['prepareses'];
    preparetrm = json['preparetrm'];
    rowid = json['rowid'];
    rowtime = json['rowtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slnum'] = this.slnum;
    data['comcod'] = this.comcod;
    data['invno'] = this.invno;
    data['invno1'] = this.invno1;
    data['refinv'] = this.refinv;
    data['refinv1'] = this.refinv1;
    data['invdat'] = this.invdat;
    data['invdat1'] = this.invdat1;
    data['invbyid'] = this.invbyid;
    data['invbyName'] = this.invbyName;
    data['sectcod'] = this.sectcod;
    data['sectname'] = this.sectname;
    data['paytype'] = this.paytype;
    data['invref'] = this.invref;
    data['invrefdat'] = this.invrefdat;
    data['custid'] = this.custid;
    data['custName'] = this.custName;
    data['placeid'] = this.placeid;
    data['placedes'] = this.placedes;
    data['delivartime'] = this.delivartime;
    data['invnar'] = this.invnar;
    data['invstatus'] = this.invstatus;
    data['poref'] = this.poref;
    data['payterm'] = this.payterm;
    data['delplac'] = this.delplac;
    data['delbyid'] = this.delbyid;
    data['delbyName'] = this.delbyName;
    data['totqty'] = this.totqty;
    data['totslam'] = this.totslam;
    data['tdisam'] = this.tdisam;
    data['netslam'] = this.netslam;
    data['tvatam'] = this.tvatam;
    data['billam'] = this.billam;
    data['collam'] = this.collam;
    data['dueam'] = this.dueam;
    data['maxcoldat'] = this.maxcoldat;
    data['maxcolid'] = this.maxcolid;
    data['prepareses'] = this.prepareses;
    data['preparetrm'] = this.preparetrm;
    data['rowid'] = this.rowid;
    data['rowtime'] = this.rowtime;
    return data;
  }
}