class ValueConfBean {
  ValueConfBean({
    this.wordRange,
    this.checkReward,
    this.wordConversion,
    this.rewardWord,
    this.wheel,
  });

  ValueConfBean.fromJson(dynamic json) {
    wordRange = json['word_range'] != null ? json['word_range'].cast<int>() : [];
    checkReward = json['check_reward'] != null ? json['check_reward'].cast<int>() : [];
    wordConversion = json['word_conversion'];
    if (json['reward_word'] != null) {
      rewardWord = [];
      json['reward_word'].forEach((v) {
        rewardWord?.add(RewardWord.fromJson(v));
      });
    }
    if (json['wheel'] != null) {
      wheel = [];
      json['wheel'].forEach((v) {
        wheel?.add(RewardWord.fromJson(v));
      });
    }
  }
  List<int>? wordRange;
  List<int>? checkReward;
  int? wordConversion;
  List<RewardWord>? rewardWord;
  List<RewardWord>? wheel;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['word_range'] = wordRange;
    map['check_reward'] = checkReward;
    map['word_conversion'] = wordConversion;
    if (rewardWord != null) {
      map['reward_word'] = rewardWord?.map((v) => v.toJson()).toList();
    }
    if (wheel != null) {
      map['wheel'] = wheel?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class RewardWord {
  RewardWord({
    this.firstNumber,
    this.wordReward,
    this.endNumber,});

  RewardWord.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    wordReward = json['word_reward'] != null ? json['word_reward'].cast<int>() : [];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  List<int>? wordReward;
  int? endNumber;
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['word_reward'] = wordReward;
    map['end_number'] = endNumber;
    return map;
  }

}