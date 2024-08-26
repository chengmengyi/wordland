
import 'package:plugin_base/utils/utils.dart';

class AdjustPointBean {
  AdjustPointBean({
      this.wrLtv0, 
      this.wrPv, 
      this.wrEcpm, 
      this.wrLevel,});

  AdjustPointBean.fromJson(dynamic json) {
    wrLtv0 = json['wr_ltv0'].toString().toDouble();
    wrPv = json['wr_pv'].toString().toDouble();
    wrEcpm = json['wr_ecpm'].toString().toDouble();
    wrLevel = json['wr_level'].toString().toDouble();
  }
  double? wrLtv0;
  double? wrPv;
  double? wrEcpm;
  double? wrLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wr_ltv0'] = wrLtv0;
    map['wr_pv'] = wrPv;
    map['wr_ecpm'] = wrEcpm;
    map['wr_level'] = wrLevel;
    return map;
  }

}