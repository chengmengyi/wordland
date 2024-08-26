
import 'package:plugin_a/dialog/incent/incent_dialog.dart';
import 'package:plugin_a/dialog/sign/sign_dialog.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/enums/sign_from.dart';
import 'package:plugin_base/routers/routers_utils.dart';

class Utils{
  static showIncentDialog({required IncentFrom incentFrom,required double addNum,Function()? dismissDialog}){
    RoutersUtils.dialog(
        child: IncentDialog(incentFrom: incentFrom,addNum: addNum,dismissDialog: dismissDialog,)
    );
  }

  static showSignDialog({required SignFrom signFrom}){
    RoutersUtils.dialog(
        child: SignDialog(signFrom: signFrom,),
        useSafeArea: false
    );
  }
}