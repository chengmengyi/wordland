import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wordland/root/root_dialog.dart';
import 'package:wordland/routers/routers_utils.dart';
import 'package:wordland/ui/b/dialog/good_comment/good_comment_con.dart';
import 'package:wordland/utils/color_utils.dart';
import 'package:wordland/widget/btn_widget.dart';
import 'package:wordland/widget/image_widget.dart';
import 'package:wordland/widget/text_widget.dart';

class GoodCommentDialog extends RootDialog<GoodCommentCon>{
  @override
  GoodCommentCon setController() => GoodCommentCon();

  @override
  Widget contentWidget() => SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: double.infinity,
            height: 320.h,
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
              children: [
                _closeWidget(),
                ImageWidget(image: "logo",width: 80.w,height: 80.w,),
                SizedBox(height: 6.h,),
                TextWidget(text: "Give Us A Good Review", color: color421000, size: 18.sp,fontWeight: FontWeight.w700,),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextWidget(text: "Complete reviews earn 5000", color: colorFF490F, size: 14.sp),
                    SizedBox(width: 8.w,),
                    ImageWidget(image: "icon_money2",width: 24.w,height: 24.w,),
                  ],
                ),
                SizedBox(height: 6.h,),
                Container(
                  width: double.infinity,
                  height: 36.w,
                  alignment: Alignment.center,
                  child: GetBuilder<GoodCommentCon>(
                    id: "list",
                    builder: (_)=>ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index)=>InkWell(
                        onTap: (){
                          rootController.clickStar(index);
                        },
                        child: Container(
                          key: index==4?rootController.lastGlobalKey:null,
                          margin: EdgeInsets.only(left: 6.w,right: 6.w),
                          child: ImageWidget(
                            image: rootController.chooseIndex>=index?"icon_start_sel":"icon_start_uns",
                            width: 36.w,
                            height: 36.w,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                BtnWidget(
                  text: "Give 5 Stars",
                  click: (){
                    rootController.clickStar(4);
                  },
                )
              ],
            ),
          ),
        ),
        GetBuilder<GoodCommentCon>(
          id: "figer",
          builder: (_)=>Positioned(
            top: rootController.lastOffset?.dy??0,
            left: (rootController.lastOffset?.dx??0)+20.w,
            child: InkWell(
              onTap: (){
                rootController.clickStar(4);
              },
              child: Lottie.asset("assets/guide1.json",width: 52.w,height: 52.w),
            ),
          ),
        )
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
        padding: EdgeInsets.all(4.w),
        child: ImageWidget(image: "icon_close",width: 24.w,height: 24.h,),
      ),
    ),
  );
}