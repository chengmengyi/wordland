import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:plugin_b/b/page/home/b_home_con.dart';
import 'package:plugin_base/root/root_page_new.dart';
import 'package:plugin_base/widget/image_widget.dart';

class BHomePage extends RootPageNew<BHomeCon>{

  @override
  BHomeCon setController() => BHomeCon();

  @override
  bool resizeToAvoidBottomInset() => false;

  @override
  Widget contentWidget() => WillPopScope(
      child: GetBuilder<BHomeCon>(
        id: "home",
        builder: (_)=>Stack(
          children: [
            _bgWidget(),
            Column(
              children: [
                Expanded(
                  child: IndexedStack(
                    index: rootController.homeIndex,
                    children: rootController.pageList,
                  ),
                ),
                _bottomList(),
              ],
            ),
            _fingerGuideWidget(),
          ],
        ),
      ),
      onWillPop: ()async{
        return false;
      });

  _bottomList()=>StaggeredGridView.countBuilder(
    itemCount: rootController.bottomList.length,
    crossAxisCount: 3,
    shrinkWrap: true,
    mainAxisSpacing: 6.w,
    crossAxisSpacing: 6.w,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.all(0),
    itemBuilder: (context, index){
      var bottomBean = rootController.bottomList[index];
      return InkWell(
        onTap: (){
          rootController.clickBottom(index);
        },
        child: Container(
          width: double.infinity,
          height: 52.h,
          alignment: Alignment.center,
          child: ImageWidget(
            image: rootController.homeIndex==index?bottomBean.selIcon:bottomBean.unsIcon,
            height: 52.h,
          ),
        ),
      );
    },
    staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
  );

  _bgWidget()=>rootController.homeIndex<2?
  ImageWidget(
    image: rootController.homeIndex==0?"answer1":"home7",
    width: double.infinity,
    height: double.infinity,
    fit: BoxFit.fill,
  ):SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: Stack(
      children: [
        ImageWidget(image: "withdraw1",width: double.infinity,height: 282.h,fit: BoxFit.fill,),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: 256.h),
            child: ImageWidget(
              image: "withdraw2",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    ),
  );


  _fingerGuideWidget()=>Align(
    alignment: Alignment.bottomCenter,
    child: GetBuilder<BHomeCon>(
      id: "finger",
      builder: (_)=>Offstage(
        offstage: !rootController.showFinger,
        child: Container(
          margin: EdgeInsets.only(left: 60.w),
          child: InkWell(
            onTap: (){
              rootController.clickBottom(1);
            },
            child: Lottie.asset("assets/guide2.json",width: 56.w,height: 56.w),
          ),
        ),
      ),
    ),
  );
}