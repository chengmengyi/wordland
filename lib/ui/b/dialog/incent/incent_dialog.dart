import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wordland/enums/incent_from.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/ui/b/dialog/incent/incent_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/image_btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class IncentDialog extends RootDialog<IncentCon>{
  IncentFrom incentFrom;
  IncentDialog({
    required this.incentFrom,
  });

  @override
  IncentCon setController() => IncentCon();

  @override
  Widget contentWidget() {
    rootController.setInfo(incentFrom);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin: EdgeInsets.only(right: 38.w),
            child: InkWell(
              onTap: (){
                rootController.clickClose();
              },
              child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
            ),
          ),
        ),
        ImageWidget(image: "incent1",height: 40.h,),
        SizedBox(height: 16.h,),
        ImageWidget(image: "icon_money1",width:172.w, height: 172.h,),
        SizedBox(height: 16.h,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(text: "+${rootController.addNum}≈", color: colorFFFFFF, size: 16.sp,fontWeight: FontWeight.w700,),
            TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(rootController.addNum)}", color: colorFF490F, size: 24.sp,fontWeight: FontWeight.w700,),
          ],
        ),
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 238.w,
              margin: EdgeInsets.only(bottom: 8.h,right: 5.w),
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
                            child: TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(NumUtils.instance.coinNum)}", color: colorF26910, size: 12.sp,fontWeight: FontWeight.w700,),
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
                        width: 238.w-(238.w)*ValueConfUtils.instance.getWithdrawProgress(),
                        height: 8.h,
                        fit: BoxFit.fill,
                      ),
                    ],
                  )
                ],
              ),
            ),
            ImageWidget(image: "icon_money2",width: 24.w,height: 24.h,),
          ],
        ),
        TextWidget(text: "Withdrawal coming soon...", color: colorCACACA, size: 12.sp),
        SizedBox(height: 30.h,),
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              margin: EdgeInsets.only(top: 16.h),
              child: ImageBtnWidget(text: "Claim",click: (){rootController.clickDouble();},),
            ),
            ImageWidget(image: "icon_double",width: 32.w,)
          ],
        )
      ],
    );
  }
}