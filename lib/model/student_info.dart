

class StudentInfo{

  String? fullName;
  //String? indexNumber;
  String? referenceNumber;
  String? studentName;
  String? program;
  String? department;
  String? campus;
  String? status;
  int? age;
  String? year; //the academic year.


  StudentInfo({
    this.fullName, 
    //this.indexNumber,
    this.referenceNumber,
    this.studentName,
    this.department,
    this.program,
    this.campus,
    this.status,
    this.age,
    this.year,
  });

  factory StudentInfo.fromMap(Map<String, dynamic> studentMap){
    return StudentInfo(
      fullName: studentMap['full_name'],
      //indexNumber: studentMap['indexNumber'],
      referenceNumber: studentMap['reference_number'],
      studentName: studentMap['student_name'],
      department: studentMap['department'],
      program: studentMap['program'],
      campus: studentMap['campus'],
      status: studentMap['status'],
      age: studentMap['age'] ?? 0,
      year: studentMap['age'].toString()
    );
  }
}