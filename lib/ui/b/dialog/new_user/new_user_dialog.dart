import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/ui/b/dialog/new_user/new_user_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/utils/value_conf_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class NewUserDialog  extends RootDialog<NewUserCon>{
  @override
  NewUserCon setController() => NewUserCon();

  @override
  Widget contentWidget() => Container(
    width: double.infinity,
    height: 421.h,
    margin: EdgeInsets.only(left: 36.w,right: 36.w),
    child: Stack(
      children: [
        GetBuilder<NewUserCon>(
          id: "pay_type",
          builder: (_)=>ImageWidget(
            image: NumUtils.instance.getNewUserBg(),
            width: double.infinity,
            height: 421.h,
            fit: BoxFit.fill,
          ),
        ),
        _closeWidget(),
        _contentWidget(),
        Positioned(
          bottom: 0,
          right: 20.w,
          child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
        )
      ],
    ),
  );

  _contentWidget()=>Container(
    width: double.infinity,
    height: 421.h,
    alignment: Alignment.center,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextWidget(text: "New user exclusive rewards", color: color272727, size: 18.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 12.h,),
        ImageWidget(image: "icon_money1",width: 120.w,height: 120.h,),
        TextWidget(text: "\$${ValueConfUtils.instance.getCoinToMoney(rootController.addNum)}", color: colorDE832F, size: 28.sp,fontWeight: FontWeight.w700,),
        SizedBox(height: 12.h,),
        Row(
          children: [
            SizedBox(width: 16.w,),
            TextWidget(text: "You can withdraw cash to：", color: color000000, size: 12.sp)
          ],
        ),
        SizedBox(height: 16.h,),
        Container(
          width: double.infinity,
          height: 48.h,
          margin: EdgeInsets.only(left: 16.w,right: 16.w),
          child: GetBuilder<NewUserCon>(
            id: "pay_type",
            builder: (_)=>ListView.builder(
              itemCount: rootController.payTypeList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context,index)=>Container(
                margin: EdgeInsets.only(right: 8.w),
                child: InkWell(
                  onTap: (){
                    rootController.clickPayType(index);
                  },
                  child: ImageWidget(
                    image: NumUtils.instance.payType==index?NumUtils.instance.getPayTypeSel():rootController.payTypeList[index],
                    width: 112.w,
                    height: 48.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h,),
        BtnWidget(
          text: "Claim Now",
          click: (){
            rootController.clickDouble();
          },
        )
      ],
    ),
  );

  _closeWidget()=>Positioned(
    top: 0,
    right: 0,
    child: InkWell(
      onTap: (){
        rootController.clickClose();
      },
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}