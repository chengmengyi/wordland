
import 'package:plugin_base/enums/task_type.dart';

class AchBean{
  String text;
  int current;
  int total;
  int addNum;
  AchType achType;
  AchBean({
    required this.text,
    required this.current,
    required this.total,
    required this.achType,
    required this.addNum,
});
}