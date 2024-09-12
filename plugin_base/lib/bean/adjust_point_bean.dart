import 'package:plugin_base/utils/utils.dart';

class AdjustPointBean {
  AdjustPointBean({
      this.wrLtv0, 
      this.wrPv, 
      this.wrLtv0Other, 
      this.wrPvOther,});

  AdjustPointBean.fromJson(dynamic json) {
    wrLtv0 = json['wr_ltv0'].toString().toDouble();
    wrPv = json['wr_pv'].toString().toDouble();
    wrLtv0Other = json['wr_ltv0_other'].toString().toDouble();
    wrPvOther = json['wr_pv_other'].toString().toDouble();
  }
  double? wrLtv0;
  double? wrPv;
  double? wrLtv0Other;
  double? wrPvOther;
}