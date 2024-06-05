import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/enums/sign_from.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/ui/b/dialog/sign/sign_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/utils/num_utils.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class SignDialog extends RootDialog<SignCon>{
  SignFrom signFrom;
  SignDialog({
    required this.signFrom
  });

  @override
  SignCon setController() => SignCon();

  @override
  Widget contentWidget(){
    rootController.setInfo(signFrom);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  height: 266.w,
                  margin: EdgeInsets.only(left: 40.w,right: 40.w),
                  child: Stack(
                    children: [
                      ImageWidget(image: "sign1",width: double.infinity,height: 266.w,fit: BoxFit.fill,),
                      _topWidget(),
                      _listWidget(),
                    ],
                  ),
                ),
                SizedBox(height: 20.h,),
                InkWell(
                  onTap: (){
                    rootController.clickClose();
                  },
                  child: ImageWidget(image: "icon_close2",width: 32.w,height: 32.h,),
                ),
              ],
            ),
          ),
          GetBuilder<SignCon>(
            id: "guide",
            builder: (_)=>Positioned(
              top: (rootController.guideOffset?.dy??0)+20.w,
              left: (rootController.guideOffset?.dx??0)+20.w,
              child: Offstage(
                offstage: null==rootController.guideOffset,
                child: InkWell(
                  onTap: (){
                    rootController.clickItem(NumUtils.instance.signDays);
                  },
                  child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  _topWidget()=>Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: EdgeInsets.only(left: 32.w,right: 32.w,top: 24.h),
        child: TextWidget(
          text: "Up to \$100 in cash to be claimed",
          color: colorFFFFFF,
          size: 20.sp,
          height: 1,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      TextWidget(text: "Come back every day to get higher rewards", color: colorFFE9E9, size: 12.sp)
    ],
  );

  _listWidget()=>Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: double.infinity,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.only(bottom: 20.h),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _signItemWidget(0),
              _signItemWidget(1),
              _signItemWidget(2),
              _signItemWidget(3),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 58.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _signItemWidget(4),
                _signItemWidget(5),
                _signItemWidget(6),
              ],
            ),
          )
        ],
      ),
    ),
  );

  _signItemWidget(index)=>InkWell(
    onTap: (){
      rootController.clickItem(index);
    },
    child: Container(
      width: 60.w,
      height: 72.w,
      key: rootController.globalList[index],
      margin: EdgeInsets.only(left: 2.w,right: 2.w),
      child: Stack(
        children: [
          ImageWidget(
            image: NumUtils.instance.signDays>index?"sign8":"sign2",
            width: 60.w,
            height: 72.w,
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextWidget(text: "${index+1}", color: colorBEBEBE, size: 10.sp,fontWeight: FontWeight.w700,),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h,),
                ImageWidget(
                    image: index==4?"sign3":index==6?"sign4":"icon_money2",
                    width: 32.w
                ),
                TextWidget(
                  text: index==6?"+\$100":"+${rootController.getSignNum(index)}",
                  color: NumUtils.instance.signDays>index?colorB6B6B6:colorFF490F,
                  size: 12.sp,
                  fontWeight: FontWeight.w700,
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}