import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unisa/app/sign_in/Home_page.dart';
import 'package:unisa/app/sign_in/academic_record.dart';
import 'package:unisa/app/sign_in/student_info.dart';
import 'package:unisa/app/sign_in/student_progress.dart';
import 'package:unisa/common_widgets/form_submit_button.dart';
import 'package:unisa/common_widgets/platform_alert_dialog.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
import 'dart:io';

import 'package:unisa/services/unisa_login.dart';

class TimeTable extends StatefulWidget {

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  bool _isLoading = false;
  List students ;
  String studentNumber;
  String timetableStatus;


  final TextEditingController studemtNumberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController examPeriodController = TextEditingController();

  String get examPeriod => examPeriodController.text;
  String get year => yearController.text;
  String get studentNr => studemtNumberController.text;



  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }



  getResults(BuildContext context) async {
    final token = Provider.of<Token>(context);
    final cookie = token.cookie;

    setState(() {
      _isLoading = true;
    });

    if(year == null || year.length < 4 || year.length > 4){

      setState(() {
        _isLoading = false;
      });
      PlatformAlertDialog(
        title: 'Year error',
        content: 'Please Enter a valid 4 digit year',
        defaultActionText: 'OK',
      ).show(context);
      yearController.clear();
    }

    if(examPeriod == null || examPeriod.length > 2){

      setState(() {
        _isLoading = false;
      });
      PlatformAlertDialog(
        title: 'Exam Period error',
        content: 'Please Enter a valid exam period',
        defaultActionText: 'OK',
      ).show(context);
      examPeriodController.clear();
    }

    if( /* studentNr == '56808453' ||*/ studentNr == null || studentNr.length < 8 || studentNr.length > 8){

      setState(() {
        _isLoading = false;
      });
      PlatformAlertDialog(
        title: 'Student No error',
        content: 'Please enter a valid student number',
        defaultActionText: 'OK',
      ).show(context);
      studemtNumberController.clear();
    }else{


      final referer = 'https://myadmin.unisa.ac.za/student/portal/student-exam-timetable-app/search';
      final header = {
        'Referer': referer,
        'Content-Type': 'application/json',
       // 'Accept' : 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'Cookie': cookie,
        'Host':'myadmin.unisa.ac.za'
      };


      final examReultsURI = 'https://myadmin.unisa.ac.za/myadmin-exam-services/services/rest/examtimetableservice/examtimetable?studentNumber=${studentNr}&academicPeriod=${examPeriod}&academicYear=${year}&practicalType=N&toolName=student-exam-timetable-app';
      //final mod_time = 'https://myadmin.unisa.ac.za/restricted-myadmin-exam-services/services/rest/examtimetableservice/examtimetable?studentNumber=56808453&academicPeriod=6&academicYear=2020&practicalType=N&toolName=student-exam-timetable-app'; //&toolName=student-exam-timetable-app/myadmin-exam-services/services/rest/examtimetableservice/examtimetable';
      final res = await http.get(examReultsURI,headers: header );
      final pro = convert.jsonDecode(res.body);


      if(res.statusCode != 200){
        final json = convert.jsonDecode(res.body);
        setState(() {
          _isLoading =false;
        });
        PlatformAlertDialog(
          title: 'Message',
          content: json['message'].toString(),
          defaultActionText: 'OK',
        ).show(context);

      }else{
        final json = convert.jsonDecode(res.body);
        final status = json['timetableStatusDesc'];


        setState(() {
          _isLoading = false;
          students = json['admissionList'];
          studentNumber = studentNr;
          timetableStatus = status;
        });

        studemtNumberController.clear();
        yearController.clear();
        examPeriodController.clear();



        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(

              students: students,
              studentNumber: studentNumber,
                timetableStatus : timetableStatus,
            ),
          ),
        );


      } //end of inner else statement

    }// end of Main else statement


  }




  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Sign Out',
      content: 'Are you sure you want to sign out',
      cancelActionText: 'Cancel',
      defaultActionText: 'Sign Out',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }


  TextField _buildYearTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Year',
          hintText: '2020'
      ),
      maxLength: 4,
      obscureText: false,
      textInputAction: TextInputAction.next,
      controller: yearController,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),

    );
  }

  TextField _buildStudentNoTextField() {

    return TextField(

      decoration: InputDecoration(
        labelText: 'Student Number',
        hintText: '56102548',
      ),
      maxLength: 8,
      autocorrect: false,
      textInputAction: TextInputAction.next,
      controller: studemtNumberController,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      enabled: _isLoading ? false : true,

    );
  }



  TextField _buildExamPeriodTextField() {

    return TextField(
      decoration: InputDecoration(
        labelText: 'Exam Period',
        hintText: 'Jan/June/Oct',
      ),
      maxLength: 2,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      controller: examPeriodController,
      enabled: _isLoading ? false : true,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
    );
  }


  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Timetable',
      style: optionStyle,
    ),
    Text(
      'Index 2: Acad Record',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if(_selectedIndex == 0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );
    } else if(_selectedIndex == 1){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TimeTable()
          )
      );
    }else if(_selectedIndex == 2){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AcademicRecord()
          )
      );
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Time Table', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon:  FaIcon(FontAwesomeIcons.stumbleuponCircle),
              iconSize: 30.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Student_progress()
                  ),
                );
              },
              tooltip: MaterialLocalizations
                  .of(context)
                  .openAppDrawerTooltip,
            );
          },
        ),
        titleSpacing: 0.0,
        actions: <Widget>[
          FlatButton(
            child: IconButton(
              icon: const Icon(Icons.perm_identity),
              iconSize: 30.0,
            ),
            onPressed: ()=> {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Student_info()
                ),
              )
            },
          ),

        ],
      ),

      body: _buildSingleChildScrollView(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: Text('Timetable'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Acad Record'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  SingleChildScrollView _buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              SizedBox(height:20.0,),
              _buildStudentNoTextField(),
              SizedBox(height: 8.0,),
              _buildYearTextField(),
              SizedBox(height: 8.0,),
              _buildExamPeriodTextField(),
              SizedBox(height: 8.0,),
              FormSubmitButton(
                text: 'Display Time Table',
                onPressed: _isLoading ? null : () => getResults(context),

              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    if(_isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 23.0,
        fontWeight: FontWeight.w600,
      ),
    );

  }




} //end of class definition



//////////////////////////////////////////////////////////////


class Chat extends StatefulWidget {
  final students;
  final studentNumber;
  final timetableStatus;



  const Chat({Key key,this.students, this.studentNumber, this.timetableStatus}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Montserrat');
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Timetable',
      style: optionStyle,
    ),
    Text(
      'Index 2: Acad Record',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if(_selectedIndex == 0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage()
          )
      );
    } else if(_selectedIndex == 1){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TimeTable()
          )
      );
    }else if(_selectedIndex == 2){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AcademicRecord()
          )
      );
    }
    
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentNumber, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),),
        elevation: 10.0,
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: IconButton(
              icon: const Icon(Icons.perm_identity),
              iconSize: 30.0,
            ),
            onPressed: ()=> {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Student_info()
                ),
              )
            },
          ),
        ],
      ),
      body: Builder(
        builder: (BuildContext context) {
          return _buildListView();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            title: Text('Timetable'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('Acad Record'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.grey[200],
    );

  }

  ListView _buildListView() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: widget.students.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: ListTile(
                isThreeLine: false,
                leading: Text(
                  '${widget.students[index]['studyUnit']}',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black87,
                      fontFamily: 'Montserrat' ,
                      fontWeight: FontWeight.w400
                  ),
                ),
                title: SizedBox(
                  height: 75.0,
                  child: Text(
                    '${widget.students[index]['examDate']}' ,
                    style:  TextStyle(color: Colors.teal, fontSize: 20.0, fontFamily: 'Montserrat' ) ,
                  ),
                ),
                subtitle: Text(
                  widget.timetableStatus,
                  style: TextStyle(color: Colors.indigo, fontSize: 20.0, fontFamily: 'Montserrat' , fontWeight: FontWeight.w300),
                ),

              ),
            ),
          ),
        );
      },
    );
  }
} //end of chat class