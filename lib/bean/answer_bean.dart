class AnswerBean{
  String result;
  String? hint;
  bool isRight;
  AnswerBean({
    required this.result,
    required this.isRight,
    this.hint,
  });
}