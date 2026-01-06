

class RegisteredCourse{

  int? classCourseId;
  String courseCode;
  String courseTitle;
  String lecturer;
  String department;
  int creditHours;
  bool evaluated;
  bool isAcceptingResponse;

  RegisteredCourse({
    required this.courseCode,
    required this.courseTitle,
    required this.lecturer,
    required this.creditHours,
    this.classCourseId,
    this.evaluated = false,
    required this.isAcceptingResponse,
    this.department=''
  });


  factory RegisteredCourse.fromJson(Map<String, dynamic> jsonMap){
    return RegisteredCourse(
      courseCode: jsonMap['course_code'],
      courseTitle: jsonMap['course_title'],
      lecturer: jsonMap['lecturer'],
      creditHours: jsonMap['credit_hours'],
      department: jsonMap['department'],
      classCourseId: jsonMap['cc_id'],
      evaluated:  jsonMap['evaluated'],
      isAcceptingResponse: jsonMap['is_accepting_response']
    );
  }

}
