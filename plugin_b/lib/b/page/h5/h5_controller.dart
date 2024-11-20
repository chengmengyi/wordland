import 'package:plugin_base/export.dart';
import 'package:plugin_base/root/root_controller.dart';
import 'package:plugin_base/routers/routers_utils.dart';

class H5Controller extends RootController{
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    webViewController=WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            var checkUrl = _checkUrl(request.url);
            if(checkUrl.isNotEmpty){
              FlutterWorkmanagerNotification.instance.openBrowser(url: checkUrl);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  void onReady() {
    super.onReady();
    _loadUrl();
  }

  _loadUrl()async{
    var gaid = await FlutterTbaInfo.instance.getGaid();
    var distinctId = await FlutterTbaInfo.instance.getDistinctId();
    var url="https://s.gamifyspace.com/tml?pid=12966&appk=jFnpPpaQq9bINJ22Wf0HF4SyKQMBS6R7&did=$gaid&cdid=$distinctId";
    webViewController.loadRequest(Uri.parse(url));
    // update(["web"]);
  }

  String _checkUrl(String url){
    if (url.startsWith("market:") ||
        url.startsWith("https://play.google.com/store/") ||
        url.startsWith("http://play.google.com/store/") ||
        url.startsWith("intent://") ||
        url.endsWith(".apk")) {
      if (url.startsWith("market://details?id=")) {
        var newUrl = url.replaceAll("market://details", "https://play.google.com/store/apps/details");
        return newUrl;
      }
      return url;
    }
    return "";
  }

  clickBack()async{
    var canGoBack = await webViewController.canGoBack();
    if(canGoBack){
      webViewController.goBack();
      return;
    }
    RoutersUtils.back();
  }
}