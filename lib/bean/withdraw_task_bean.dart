enum WithdrawTaskType{
  sign,level10,level20,collectBubble,wheel,level50
}

class WithdrawTaskBean{
  String text;
  int current;
  int total;
  String btn;
  WithdrawTaskType type;
  WithdrawTaskBean({
    required this.text,
    required this.current,
    required this.total,
    required this.btn,
    required this.type,
});
}