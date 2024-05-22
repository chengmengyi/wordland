import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/storage/storage_name.dart';
import 'package:wordland/storage/storage_utils.dart';
import 'package:wordland/ui/b/dialog/new_user/new_user_dialog.dart';
import 'package:wordland/utils/guide/guide_step.dart';

class GuideUtils{
  factory GuideUtils() => _getInstance();

  static GuideUtils get instance => _getInstance();

  static GuideUtils? _instance;

  static GuideUtils _getInstance() {
    _instance ??= GuideUtils._internal();
    return _instance!;
  }

  GuideUtils._internal();

  checkNewUserGuide(){
    var newUserGuideStep = StorageUtils.read<int>(StorageName.newUserGuideStep)??NewUserGuideStep.showNewUserDialog;
    switch(newUserGuideStep){
      case NewUserGuideStep.showNewUserDialog:
        RoutersUtils.dialog(child: NewUserDialog());
        break;
      case NewUserGuideStep.showIncentDialog:
        RoutersUtils.showIncentDialog(incentFrom: IncentFrom.newUserGuide);
        break;
      case NewUserGuideStep.showSignDialog:
        RoutersUtils.showSignDialog(signFrom: SignFrom.newUserGuide);
        break;
    }
  }

  updateNewUserGuideStep(int step){
    StorageUtils.write(StorageName.newUserGuideStep, step);
    checkNewUserGuide();
  }
}