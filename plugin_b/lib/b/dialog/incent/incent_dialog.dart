import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/b/dialog/incent/incent_con.dart';
import 'package:plugin_base/enums/incent_from.dart';
import 'package:plugin_base/language/local.dart';
import 'package:plugin_base/root/root_dialog.dart';
import 'package:plugin_base/utils/color_utils.dart';
import 'package:plugin_base/utils/new_value_utils.dart';
import 'package:plugin_base/utils/num_utils.dart';
import 'package:plugin_base/utils/utils.dart';
import 'package:plugin_base/widget/image_btn_widget.dart';
import 'package:plugin_base/widget/image_widget.dart';
import 'package:plugin_base/widget/text_widget.dart';

class IncentDialog extends RootDialog<IncentCon>{
  IncentFrom incentFrom;
  double addNum;
  Function()? dismissDialog;

  IncentDialog({
    required this.incentFrom,
    required this.addNum,
    this.dismissDialog,
  });

  @override
  IncentCon setController() => IncentCon();

  @override
  Widget contentWidget() {
    rootController.setInfo(incentFrom,addNum);
    return Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset(
          "assets/pen.json",
          width: double.infinity,
          height: double.infinity
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(right: 38.w),
                child: InkWell(
                  onTap: (){
                    rootController.clickClose(dismissDialog);
                  },
                  child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
                ),
              ),
            ),
            ImageWidget(image: "incent1",height: 40.h,),
            SizedBox(height: 16.h,),
            ImageWidget(image: getMoneyIcon(),width:172.w, height: 172.h,),
            SizedBox(height: 16.h,),
            TextWidget(text: "+${getOtherCountryMoneyNum(rootController.addNum)}", color: colorFF490F, size: 24.sp,fontWeight: FontWeight.w700,),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 238.w,
                  margin: EdgeInsets.only(bottom: 20.h,right: 5.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<IncentCon>(
                        id: "progressMarginLeft",
                        builder: (_)=>Container(
                          key: rootController.globalKey,
                          margin: EdgeInsets.only(left: rootController.progressMarginLeft),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 4.w,right: 4.w),
                                decoration: BoxDecoration(
                                  color: colorFFFFFF,
                                  borderRadius: BorderRadius.circular(8.w),
                                ),
                                child: TextWidget(text: getOtherCountryMoneyNum(NumUtils.instance.userMoneyNum), color: colorF26910, size: 12.sp,fontWeight: FontWeight.w700,),
                              ),
                              ImageWidget(image: "icon_down_arrow",height: 2.h,),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h,),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          ImageWidget(image: "icon_pro",width: 238.w,height: 8.h,fit: BoxFit.fill,),
                          ImageWidget(
                            image: "icon_pro_bg",
                            width: 238.w-(238.w)*NewValueUtils.instance.getCashProgress(),
                            height: 8.h,
                            fit: BoxFit.fill,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ImageWidget(image: Platform.isIOS?"icon_money2":"icon_money4",width: 24.w,height: 24.h,),
                    TextWidget(text: getOtherCountryMoneyNum(NewValueUtils.instance.getCurrentCashRange().toDouble()), color: colorF26910, size: 12.sp,fontWeight: FontWeight.w700,),
                  ],
                ),
              ],
            ),
            TextWidget(text: Local.withdrawalComing.tr, color: colorCACACA, size: 12.sp),
            SizedBox(height: 30.h,),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16.h),
                  child: ImageBtnWidget(text: Local.claim.tr,click: (){rootController.clickDouble(dismissDialog);},),
                ),
                ImageWidget(image: "icon_double",width: 32.w,)
              ],
            )
          ],
        ),
      ],
    );
  }
}