class Accommodation{
  //basic layout of what information there would be per accommodation
  Accommodation({this.id, this.name, this.desc, required this.assessments});
  int? id;
  //Below, we have 'name' for 'what is this accommodation called
  String? name;
  //'desc' is description
  String? desc;
  //'assessments' details what assessments get affected by this accommodation
  List<String> assessments = [''];
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'notes': desc,
      'assements': assessments,
    };
  }

  Accommodation.fromMap(Map map) {

    this.id=map['id'];
    this.name=map['name'];
    this.desc=map['notes'];
    this.assessments=map['assessments'];
  }

}
