// class NewUserGuideStep{
//   static const int showNewUserDialog=0;
//   static const int showIncentDialog=1;
//   static const int showSignDialog=2;
//   static const int showWordsGuide=3;
//   static const int completeNewUserGuide=4;
// }

class OldUserGuideStep{
  static const int showSignDialog=0;
  // static const int showTaskBubbleGuide=1;
  // static const int showWordsGuide=2;
  static const int completeOldUserGuide=3;
}

enum BPackageOldUserGuideStep{
  showSignDialog,showWheelGuideOverlay,completed
}


enum NewNewUserGuideStep{
  newUserDialog,newUserWordsGuide,showHomeBubble,complete
}

enum BPackageNewUserGuideStep{
  newUserDialog,withdrawSignBtnGuide,showSignDialog,level20Guide,showRightWordsGuide,showHomeBubbleGuide,completed
}