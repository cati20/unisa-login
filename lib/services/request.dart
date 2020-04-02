import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;


class Requests extends StatelessWidget {


  void testAxios () async{
    final res = http.get("https://myadmin.unisa.ac.za/myadmin-exam-services/services/rest/examtimetableservice/examtimetable?studentNumber=69469490&academicPeriod=6&academicYear=2020&practicalType=N&toolName=student-exam-timetable-app");

    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
