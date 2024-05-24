import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wordland/root/root_controller.dart';
import 'package:wordland/widget/image_widget.dart';

abstract class RootPageStatefull extends StatefulWidget{

}

abstract class RootPageState<T extends RootPageStatefull,K extends RootController> extends State<T>{
  late K rootController;

  @override
  void initState() {
    var c = setController();
    var tag = c.runtimeType.toString();
    Get.put(c,tag: tag);
    rootController = Get.find<K>(tag: tag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rootController.context=context;
    return Scaffold(
      body: Stack(
        children: [
          bgName().isEmpty?
          const SizedBox():
          ImageWidget(image: bgName(),width: double.infinity,height: double.infinity,fit: BoxFit.fill,),
          SafeArea(
            top: true,
            bottom: true,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: contentWidget(),
            ),
          )
        ],
      ),
    );
  }

  K setController();

  String bgName()=> "";

  Widget contentWidget();
}