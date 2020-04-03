import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisa/app/sign_in/academic_record_details.dart';
import 'package:unisa/app/sign_in/sign_in_page.dart';
import 'package:unisa/app/sign_in/time_table.dart';
import 'package:unisa/common_widgets/form_submit_button.dart';
import 'package:unisa/common_widgets/platform_alert_dialog.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
import 'package:unisa/services/unisa_login.dart';
import 'dart:io';

import 'academic_record.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  List students ;
  String studentNumber;
  String all_access;


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
      PlatformAlertDialog(
        title: 'Sign Out Error',
        content: e.message.toString(),
        defaultActionText: 'OK',
      );
    }
  }
  


  getResults(BuildContext context) async {
    final token = Provider.of<Token>(context);
    final all_access = token.cookie;

    if(all_access != null) {
      setState(() {
        _isLoading = true;
      });

      if (year == null || year.length < 4 || year.length > 4) {
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

      if (examPeriod == null || examPeriod.length > 2) {
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

      if (studentNr == '56808453' || studentNr == null ||
          studentNr.length < 8 || studentNr.length > 8) {
        setState(() {
          _isLoading = false;
        });
        PlatformAlertDialog(
          title: 'Student No error',
          content: 'Please enter a valid student number',
          defaultActionText: 'OK',
        ).show(context);
        studemtNumberController.clear();
      } else {
        final referer = 'https://myadmin.unisa.ac.za/student/portal/exam-results-app/search';
        final header = {
          'Referer': referer,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Cookie': all_access
        };


        final examReultsURI = 'https://myadmin.unisa.ac.za/restricted-myadmin-exam-services/services/rest/examresultservice/examresults?academicYear=${year}&academicPeriod=${examPeriod}&studentNumber=${studentNr}';

        final res = await http.get(examReultsURI, headers: header);

        if (res.statusCode != 200) {
          final json = convert.jsonDecode(res.body);
          setState(() {
            _isLoading = false;
          });
          PlatformAlertDialog(
            title: 'Message',
            content: json['message'].toString(),
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final json = convert.jsonDecode(res.body);

          setState(() {
            _isLoading = false;
            students = json['courseResult'];
            studentNumber = studentNr;
          });

          studemtNumberController.clear();
          yearController.clear();
          examPeriodController.clear();


          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Chat(

                    students: students,
                    studentNumber: studentNr,
                  ),
            ),
          );
        } //end of inner else statement


      } //

    }else{
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SignInPage(),
        ),
      );

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
      obscureText: false,
      textInputAction: TextInputAction.next,
      controller: yearController,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      enabled: _isLoading ? false : true,

    );
  }

  TextField _buildStudentNoTextField() {

    return TextField(

      decoration: InputDecoration(
        labelText: 'Student Number',
        hintText: '56102548',
      ),
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
      autocorrect: false,
      textInputAction: TextInputAction.done,
      controller: examPeriodController,
      enabled: _isLoading ? false : true,
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),

    );
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Monserrat');
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
          title: Text('Exam Details', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 30.0,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
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
                  icon: const Icon(Icons.input),
                  iconSize: 30.0,
                ),
                onPressed: ()=> _confirmSignOut(context),
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
                      text: 'Get results',
                      onPressed: _isLoading ? null : () => getResults(context),

                    ),
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



  const Chat({Key key,this.students, this.studentNumber}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

//for buttom navigation bar

  int _selectedIndex = 0;
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




///////////////////////////

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Exam Results',
            style: TextStyle(fontFamily: 'Montserrat' , fontWeight: FontWeight.w600)
        ),
        elevation: 10.0,
        centerTitle: true,
        actions: <Widget>[
        ],
      ),
      body: _buildBuilder(),

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

  Builder _buildBuilder() {
    return Builder(
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: widget.students.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Dismissible(
                   key: Key('${widget.students[index]['course']}'),
                    onDismissed: (direction){
                      setState(() {
                        widget.students.removeAt( index);
                      });
                      if(direction == DismissDirection.startToEnd){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsScreen(details: widget.students[index],)
                            )
                        );
                      }
                    },
                    background: Container(
                      color: Colors.cyan,
                      child: Text(
                          'Show details',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.center,
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                    child: ListTile(
                      isThreeLine: false,
                      leading: Text(
                          '${widget.students[index]['course']}',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                          color: Colors.black87
                        ),
                      ),
                      title: SizedBox(
                        height: 30.0,
                        child: Text(
                            '${widget.students[index]['description']}' == 'Supplementary Examination' ? 'Supp Exam' : '${widget.students[index]['description']}',
                            style: '${widget.students[index]['description']}' =='Failed' ? TextStyle(color: Colors.red, fontSize: 20.0 ,                        fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,)  : TextStyle(color: Colors.green, fontSize: 20.0 ,                        fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,),
                        ),
                      ),
                      trailing: Text(
                          '${widget.students[index]['finalMark']}',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            );
          },
        );


      },
    );
  }
}