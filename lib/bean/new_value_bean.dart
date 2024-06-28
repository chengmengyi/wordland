class NewValueBean {
  NewValueBean({
      this.wordRange, 
      this.newReward, 
      this.checkReward, 
      this.intAd, 
      this.rvAd, 
      this.rewardWord, 
      this.levelReward, 
      this.wheelReward, 
      this.floatReward,});

  NewValueBean.fromJson(dynamic json) {
    wordRange = json['word_range'] != null ? json['word_range'].cast<int>() : [];
    newReward = json['new_reward'];
    checkReward = json['check_reward'] != null ? json['check_reward'].cast<int>() : [];
    if (json['int_ad'] != null) {
      intAd = [];
      json['int_ad'].forEach((v) {
        intAd?.add(IntAd.fromJson(v));
      });
    }
    if (json['rv_ad'] != null) {
      rvAd = [];
      json['rv_ad'].forEach((v) {
        rvAd?.add(IntAd.fromJson(v));
      });
    }
    if (json['reward_word'] != null) {
      rewardWord = [];
      json['reward_word'].forEach((v) {
        rewardWord?.add(FloatReward.fromJson(v));
      });
    }
    if (json['level_reward'] != null) {
      levelReward = [];
      json['level_reward'].forEach((v) {
        levelReward?.add(FloatReward.fromJson(v));
      });
    }
    if (json['wheel_reward'] != null) {
      wheelReward = [];
      json['wheel_reward'].forEach((v) {
        wheelReward?.add(FloatReward.fromJson(v));
      });
    }
    if (json['float_reward'] != null) {
      floatReward = [];
      json['float_reward'].forEach((v) {
        floatReward?.add(FloatReward.fromJson(v));
      });
    }
  }
  List<int>? wordRange;
  int? newReward;
  List<int>? checkReward;
  List<IntAd>? intAd;
  List<IntAd>? rvAd;
  List<FloatReward>? rewardWord;
  List<FloatReward>? levelReward;
  List<FloatReward>? wheelReward;
  List<FloatReward>? floatReward;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['word_range'] = wordRange;
    map['new_reward'] = newReward;
    map['check_reward'] = checkReward;
    if (intAd != null) {
      map['int_ad'] = intAd?.map((v) => v.toJson()).toList();
    }
    if (rvAd != null) {
      map['rv_ad'] = rvAd?.map((v) => v.toJson()).toList();
    }
    if (rewardWord != null) {
      map['reward_word'] = rewardWord?.map((v) => v.toJson()).toList();
    }
    if (levelReward != null) {
      map['level_reward'] = levelReward?.map((v) => v.toJson()).toList();
    }
    if (wheelReward != null) {
      map['wheel_reward'] = wheelReward?.map((v) => v.toJson()).toList();
    }
    if (floatReward != null) {
      map['float_reward'] = floatReward?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class FloatReward {
  FloatReward({
      this.firstNumber, 
      this.wordReward, 
      this.endNumber,});

  FloatReward.fromJson(dynamic json) {
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

class IntAd {
  IntAd({
      this.firstNumber, 
      this.point, 
      this.endNumber,});

  IntAd.fromJson(dynamic json) {
    firstNumber = json['first_number'];
    point = json['point'];
    endNumber = json['end_number'];
  }
  int? firstNumber;
  int? point;
  int? endNumber;
  
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_number'] = firstNumber;
    map['point'] = point;
    map['end_number'] = endNumber;
    return map;
  }

}