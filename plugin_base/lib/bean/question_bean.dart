class QuestionBean{
  String question;
  String answer;
  List<String>? answerList;

  QuestionBean({
    required this.question,
    required this.answer,
    this.answerList,
  });

  @override
  String toString() {
    return 'QuestionBean{question: $question, answer: $answer, answerList: $answerList}';
  }
}