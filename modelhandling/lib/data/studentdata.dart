class Student {
  final int? id;
  final String name;
  final double quiz;
  final double activity;
  final double exam;

  Student({
    this.id,
    required this.name,
    required this.quiz,
    required this.activity,
    required this.exam,
  });


  double get average => (quiz + activity + exam) / 3;

 
  String get status => average >= 75 ? 'Passed' : 'Failed';


  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      quiz: double.parse(map['quiz'].toString()),
      activity: double.parse(map['activity'].toString()),
      exam: double.parse(map['exam'].toString()),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'quiz': quiz,
      'activity': activity,
      'exam': exam,
    };
  }
}
