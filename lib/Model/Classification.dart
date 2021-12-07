class Classification {
  int id;
  String picture_name;
  int picture_classification;
  Classification(this.id, this.picture_name, this.picture_classification);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'picture_name': picture_name,
      'picture_class': picture_classification
    };
    return map;
  }
  Classification.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    picture_name = map['picture_name'];
    picture_classification = int.parse(map['picture_class']);
  }
}

