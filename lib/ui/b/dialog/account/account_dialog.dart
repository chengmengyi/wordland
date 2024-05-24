import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/account/account_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class AccountDialog extends RootDialog<AccountCon>{
  int chooseNum;
  AccountDialog({
    required this.chooseNum,
  });
  @override
  AccountCon setController() => AccountCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 332.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.w),
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorFFFEFA,colorE8DEC8]
        )
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _closeWidget(),
        TextWidget(text: "Congratulations!", color: color421000, size: 16.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 8.h,),
        TextWidget(text: "\$$chooseNum", color: colorDE832F, size: 28.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 8.h,),
        Container(
          width: double.infinity,
          height: 44.h,
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: 12.w,right: 12.w),
          decoration: BoxDecoration(
            color: colorFFFFFF,
            borderRadius: BorderRadius.circular(22.w),
          ),
          child: TextField(
            enabled: true,
            maxLength: 20,
            textAlign: TextAlign.center,
            controller: rootController.editingController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14.sp,
              color: color333333,
            ),
            decoration: InputDecoration(
              counterText: '',
              isCollapsed: true,
              hintText: 'Please input your account',
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: colorB5AE9B,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 8.h,),
        Container(
          margin: EdgeInsets.only(left: 12.w,right: 12.w),
          child: TextWidget(text: "Your cash will arrive in your account within 3-7 business days. Please keep an eye on your account!", color: color8F7E53, size: 12.sp),
        ),
        SizedBox(height: 8.h,),
        BtnWidget(text: "Withdraw Now", click: (){rootController.clickWithdraw(chooseNum);})
      ],
    ),
  );

  _closeWidget()=>Align(
    alignment: Alignment.topRight,
    child: InkWell(
      onTap: (){
        RoutersUtils.back();
      },
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}