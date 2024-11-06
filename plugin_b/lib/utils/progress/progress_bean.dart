enum ProStatus{
  received,current,grey,
}

enum ProType{
  box,wheel,
}

class ProgressBean {
  int index;
  ProStatus proStatus;
  ProType proType;
  ProgressBean({
    required this.index,
    required this.proStatus,
    required this.proType,
  });

  @override
  String toString() {
    return 'ProgressBean{index: $index, proStatus: $proStatus, proType: $proType}';
  }
}