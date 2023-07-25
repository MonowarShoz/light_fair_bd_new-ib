class ProcessAccessParams2 {
  String? comCod;
  String? procName;
  String? parm01;
  String? parm02;
  String? parm03;
  String? parm04;
  String? parm05;
  String? parm06;
  String? parm07;
  String? parm08;
  String? parm09;
  String? parm10;
  String? parm11;
  String? parm12;
  String? parm13;
  String? parm14;
  String? parm15;

  ProcessAccessParams2({
    this.comCod,
    this.procName,
    this.parm01,
    this.parm02,
    this.parm03,
    this.parm04,
    this.parm05,
    this.parm06,
    this.parm07,
    this.parm08,
    this.parm09,
    this.parm10,
    this.parm11,
    this.parm12,
    this.parm13,
    this.parm14,
    this.parm15,
  });

  ProcessAccessParams2.fromJson(Map<String, dynamic> json) {
    comCod = json['comCod'];
    procName = json['procName'];
    parm01 = json['parm01'];
    parm02 = json['parm02'];
    parm03 = json['parm03'];
    parm04 = json['parm04'];
    parm05 = json['parm05'];
    parm06 = json['parm06'];
    parm07 = json['parm07'];
    parm08 = json['parm08'];
    parm09 = json['parm09'];
    parm10 = json['parm10'];
    parm11 = json['parm11'];
    parm12 = json['parm12'];
    parm13 = json['parm13'];

    parm14 = json['parm14'];
    parm15 = json['parm15'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comCod'] = this.comCod;
    data['procName'] = this.procName;
    data['parm01'] = this.parm01;
    data['parm02'] = this.parm02;
    data['parm03'] = this.parm03;
    data['parm04'] = this.parm04;
    data['parm05'] = this.parm05;
    data['parm06'] = this.parm06;
    data['parm07'] = this.parm07;
    data['parm08'] = this.parm08;
    data['parm09'] = this.parm09;
    data['parm10'] = this.parm10;
    data['parm11'] = this.parm11;
    data['parm12'] = this.parm12;
    data['parm13'] = this.parm13;

    data['parm14'] = this.parm14;
    data['parm15'] = this.parm15;

    return data;
  }
}
