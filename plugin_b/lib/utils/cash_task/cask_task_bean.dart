class CaskTaskBean {
  CaskTaskBean({
      this.taskName, 
      this.cashType, 
      this.cashNum, 
      this.taskPro, 
      this.signPro, 
      this.account,
      this.taskComplete,
  });

  CaskTaskBean.fromJson(dynamic json) {
    taskName = json['taskName'];
    cashType = json['cashType'];
    cashNum = json['cashNum'];
    taskPro = json['taskPro'];
    signPro = json['signPro'];
    account = json['account'];
    taskComplete = json['taskComplete'];
  }
  String? taskName;
  int? cashType;
  int? cashNum;
  int? taskPro;
  int? signPro;
  int? taskComplete;
  String? account;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['taskName'] = taskName;
    map['cashType'] = cashType;
    map['cashNum'] = cashNum;
    map['taskPro'] = taskPro;
    map['signPro'] = signPro;
    map['account'] = account;
    map['taskComplete'] = taskComplete;
    return map;
  }

}