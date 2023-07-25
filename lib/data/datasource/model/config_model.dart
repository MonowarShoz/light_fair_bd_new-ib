class UserConfigModel {
  String? token;
  String? expiration;
  String? empId;
  EmpInfo? empInfo;
  int? zoneId;
  // void empZoneList;
  List<EmpMenuList>? empMenuList;
  String? approver;
  String? privilage;

  UserConfigModel(
      {this.token,
      this.expiration,
      this.empId,
      this.empInfo,
      this.zoneId,
      //  this.empZoneList,
      this.empMenuList,
      this.approver,
      this.privilage});

  UserConfigModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    empId = json['empId'];
    empInfo =
        json['empInfo'] != null ? EmpInfo.fromJson(json['empInfo']) : null;
    zoneId = json['zoneId'];
    // empZoneList = json['empZoneList'];
    if (json['empMenuList'] != null) {
      empMenuList = <EmpMenuList>[];
      json['empMenuList'].forEach((v) {
        empMenuList!.add(EmpMenuList.fromJson(v));
      });
    }
    approver = json['approver'];
    privilage = json['privilage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = token;
    data['expiration'] = expiration;
    data['empId'] = empId;
    if (empInfo != null) {
      data['empInfo'] = empInfo!.toJson();
    }
    data['zoneId'] = zoneId;
    //   data['empZoneList'] = empZoneList;
    if (empMenuList != null) {
      data['empMenuList'] = empMenuList!.map((v) => v.toJson()).toList();
    }
    data['approver'] = approver;
    data['privilage'] = privilage;
    return data;
  }
}

class EmpInfo {
  String? name;
  String? wDesig;
  String? sDesig;
  String? photo;

  EmpInfo({this.name, this.wDesig, this.sDesig, this.photo});

  EmpInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    wDesig = json['wDesig'];
    sDesig = json['sDesig'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['wDesig'] = wDesig;
    data['sDesig'] = sDesig;
    data['photo'] = photo;
    return data;
  }
}

class EmpMenuList {
  num moduleID;
  String? moduleName;
  String? objID;
  String? objName;

  EmpMenuList(
      {required this.moduleID, this.moduleName, this.objID, this.objName});

  factory EmpMenuList.fromJson(Map<String, dynamic> json) {
    return EmpMenuList(
      moduleID: json['moduleID'],
      moduleName: json['moduleName'],
      objID: json['objID'],
      objName: json['objName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['moduleID'] = moduleID;
    data['moduleName'] = moduleName;
    data['objID'] = objID;
    data['objName'] = objName;
    return data;
  }
}
