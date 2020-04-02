import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisa/app/sign_in/sign_in_page.dart';
import 'package:unisa/app/sign_in/time_table.dart';
import 'package:unisa/common_widgets/form_submit_button.dart';
import 'package:unisa/common_widgets/platform_alert_dialog.dart';
import 'package:unisa/services/auth.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
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
  


  Future<String> getCookie(BuildContext context) async{
   final url = "https://cas.unisa.ac.za/cas/login?service=https%3a%2f%2fmyadmin.unisa.ac.za%2fmyadmin-auth-services%2fservices%2frest%2fauthservice%2fuser";

   String execution = "c78cf1c1-202d-40ed-a360-7cc73d88bece_ZXlKaGJHY2lPaUpJVXpVeE1pSjkubmhPb2ZHMloveHAxNmJyY3R2eXY0T0l4OVczbHFVa2RvS0s3UDhYOTF6NG1LdkxmQTIzVEhXVURjQ1hERnhQdVNES1RSblVMT0xEMFV6WFFDbmwrTGl0dGFxVDNDOWZvSWFqK25kSmxUY2h4M09aa2M5NHh4QUJoQ2U4UHpkWVlrWDB3aGZQZWVJdnEwbCt0cmU2d0dnallMeEVVK1ZrTHJHVVUvU2thRGJ2N1B0NTR5UEJreEowSmtiZ0ZUMHNTMmg2MFZzaGZLazdybFlSaSttYlB5UmN4c2w0VlRIRlFacVN3by9FNWQ1OGtPNHgzRE5qU1hXU2ZGUkpaNzA3VXpnT2toZ25EMEtzNnlodDhyM3pGTlNBL3hEVlpKS0JSVy90L2ZQazBCY3JTbTk1Yk92MnplRzBib2JUNVZUb1lKVjdPYTg0a2dYaG9rbE1SYWlld2ZqcFZxbEhDeWJSbW15OUdxVnExTTFXR0t6MXZ5a1VRWTI2cEhtQ3ZIS0p4SFhWWFlnQkdDNEpvalRmT3RwYWUzS1BKSFl5M3doS1BHeVlsdndjSU1YMnEzUjh2UkJhRGxyNC9VWGUwTmsxNEw3eVlTVVZOV2dPWkVnSVQvSDBDU3phUzhkSXRxZGpnd2NuTURwL3NCTyt0elNFRVZKODhaQVBYMjNsNlBmUjk0dUp2ZlgrSS92UDhvNTFCb1VPakJBSUgvcXoweWNDQ0ViUkowVGpXZjZRN1VSNTQ1Y05xOFk4VHBWRXlrenE5SWxRdUo0L0JrUmZyUnczZHk4cWNSMm55OFBwS2J5dk5pZ0VscTdJbi9jWmVIUkg1Mkw3Mm1RZFl0azArbitVS0h0TzcyMjRzVG1WL3FScnVSQVpXU0JqSlF4WmZ3Rks2anhPbHh6US9YME0rdlM3blRrVGFOa1E4ZEwyTzhIS0NrUnpnUlVTbEJrM2hva1ZnNzlVdWcwMlFvUE0vR21Ma3d2SVNrbFk3Z2VKTUlTMUYzc3VvR2VPMnlPT0VTMjBGQzlkMjBqYmwyandNYWxZb05IRUMyZHBmcDl5Y0VSNmZ0aHBIQ284cy82b2F0QkdDWXlGSFAxbDhTNnY5ZStnZlhjbEpFMGRjb0c4ODJjMmVyeVRnMWI2NmQ0bGh4RTdOZHU3N3VkMXd0WGo2VzJrai9MUHZETE1RUVhScklEaDh3Q2pIMXZud0k2NXlJOVZIbnMxV2JPUHpsWWZoZENlZks0WFVLSEJGdzZCSytybzlxLzVpbWt5ZDdhYTJ4Zm9CTVpMbjcrdVFmUGYwNzFxTnZLTHNsem0rQ0ZRNnk3Y0N5WVlUQk1TQ3J6TElUdGJzd2F2S1dCaVRmRnN1UysweFk3Ymo1QUxEQnR5eGZva2ZqemwvSDdIUVlLT1R0SGxaK1ZybHhaK2hwamJhSTZYZkFxVzRpMHkyRW4rU0lYSUc5cnlLTFd3V1VDV0R4L0ZuVlp4bGlPNThPREtjZ1R5WjVNdUszRE5uUHFDQ2VQV3h1ZVZBcFE4bGU2T2d5S1FnSTJJa3RnMm5SN0ZEeTRzRkw2L1hRYlN6VUR0YXhiSGk1b0tiUyt6YUZkdWpQSlloZTB2bExDZTlLdjZBekJJVnM0QWMzekl3V05GamtLc0g3alNHMmovenFpRWNwa2dqZ3VRN2dZSURNSlhMbkV0S3pqbmZ6aUEvRHhuZS80VnRubndadGtKQzRUdUhWWTNNcXQ4WFdVQ0dHcUhuajJEUm0rV0lsaG84NHBZNTdWVkpWYyt4aS9BL0tUeFNsV1lNT1hGREQ5RFBXVDFoZUt4b1RBQUpSQkpod1VtckNxUHFCVzhIWS9DcXZ1Vk9JWFl2aE5Ld2g1VnY1YVhTd25sTlZ5aFEvdXkvUWYzMjJsL293eXFuM0NENnNkUUVRMExkRlo3VDU5MmRFOEkwRDBMWjlaeWc2cW4xZmoxV0VEaWl3N1daeGVtUFg3dHI2dXVURHVPQ3VsWXEvTlNwL2lJUGoyQnFqWW8yVitGblNPNzNnWHFzVWV1enhnM3kycENKa0p5S2lwU0VxMzU2bEJGVE8vYmhNK0VZUm1pcE82eGNiYUlmdThTUVQ1eDVmcEZwdVF3M0Q0VjQvRWQ4VEtoanBMUkVqdlQwYlplREFUU3NEaWQxT2diOTVQUWVvMHd4UGtKMEQwdFlDamJsbzNQek5jUkRQQ3UvSFlhQWVuYUtkZ3NvU1MzQmdrS2xvQWNVc2pYcUtja09DUWZRSlRpYy9NdWhpVkNnbk9GYWdRbEVpbU1sMi9RVlEyd2htNkdvaDd1ZXAvRXVPdkMwUXBDMXJBb3pzdkdERG1vYzdPV09CRVBQS1JCY1hPMjRELzB1WDdoRG0xTXhmRmF3YXBnUVZ2L0ZhVmMwdHJObVFXWjRubHN3b1lVWG92M3lyQ1BpRXR3ZTR1MzFMbE55elFna1BsUHlYRGJ2UkN6ZlUzMVFZVmk2OHZaVFVUdlJwN1NxZU53R0ZRSEkvWWc4MkI5RFBMZFhLanU4aUNtVXhwby9Da2dHOTVlVmticFlMWGFBNkFsMjVwRzdWMjRaVml1WHJUaGFFdFMvSFR5UU4zZEduQVgvOHBsQ1ZOTklyYlI5WVFMQmRyQ1ZtcVgyNDlBVFlKVFQrZCthNFNVbmoxNFBXenIyaGcya2NVYTNONXIxWDYzWU54aGVLQWNMOFZ1Mld0SW10bVJ0RDZ5RjZqdTJZK0JtdDhtWDExa215NkNBRFlhSUVGL3NRaXJwTXpmQ25SU1VuYURJWGVMeGdvTHJQUUp6NitDR3EzUVpLcUxYQ2x6K0FXbFZSdS9BVEc4RDEzK0RqOXhNYzZhci9iMzFLZVJjN052VHFwMXA1VVVYcjlobWlYMS9hRnVUWHhRdTQ3UFB1MXd1U1QraGxWenQxY2hvZjc0V0V0NktzNm5td1ZVakJvL2pLSlRPTUF6aUpyM0VtcTdaY1JPNytVNVNRZFc1dm1UckxSZnl5WVFRYzE2Mlp4OEFlam1wVDNPd0ZyeDdjeGpPSHpmTlJJTWJzL2Rkam5JTWhEVUlxSE1KbEZmR0l6blNXVFZIR2JMTXNOSk5nQ1NWNXREL2RzMzdqWFByTkJFTFhRMWVaUG05QVZCVEIxNUJtWlZlUWpRNUh4czBUSDc0RER0REdXbVRsYWJ5WC9sbUdqclk1N3lyVVM0QWFuZ09tN2hxUjhpZng1ZmdzcEJKOUNkMlo0dVJPV3NScjE3OEJPU3U2UXRhc1grYzhCdEZsWlBEWHViVTBLVW5YeWE4ckhzSDNnV2Q5a0ZHVHpraWxXRy8yaW02eUhsUmVkQUg5dHdMRXlvQndKU0ZObHNlY1IvZnplVEYzUUxMWmJUaE1YTFdvc21RUGxvOGkvWUQzUllOOTlxVCt3ZU5HMHRscDhXNXFFT0laUEMvcnE4TlVnYUx6YXhUYUp5WjhIL3BQTGxWdDI4NVRmQ0p4d25jeXJJOFBteWRzcnNMTDdkN2toM1ZTRVZQRkNlSUVBQ2lBNE1KN1FKMVBUMlNmZXh2Qmx4bjhjN29Kd3l4dkQrLzlnTm1DMEltZlRhaHFhcUFjYWRoZk4xVzUxNXlFcXEwNFF4WkE1SUNzMGk1OUFUU2ZORFgwWHhmcXdLR3g4amkxeWx3cm5BRHpSS1ZIT2crT0xCRXlXODBuTFFGTEI4SnJiY2Q3UkpzYk9hL3NkZ09kMVJJUEtPcGViN0ZqNVlxZFE2SktlR2l3dFpNU0R3d3JZVlk0UzB4SXR2b3ZOZGN0UngrUDdHbkJLVzRqdXNCSnVRaHFiVWx3cHRrcDlTOG13aVFkMWZQaUl1REExbkJ5Y04zZWIxTG1yQUpLU2VkbUhJdGx4U2w2NXVZMm1KeXVhZGFHY25hTmRjc3MyaGZTYWJ0ZFJoMi5aZWVacjJkY1E1NDU3aFNQSUFPa2lqMWxDUWNmV3BVVUpJV1E1ekRyV1hNSDFRZDFtZUtfMnd1RTlWcEo2Nm1aVHpva25UMFYtR3NmcW5LV1MtVlh1dw==";
   //final service = 'https%3a%2f%2fmyadmin.unisa.ac.za%2fmyadmin-auth-services%2fservices%2frest%2fauthservice%2fuser';

   final referer = 'https://myadmin.unisa.ac.za/student/portal/exam-results-app/search';
   final header = {
     'Referer': referer,
     //'Content-Type': 'application/json',
     'Accept-Charset': 'utf-8',
     'Accept' : 'application/json'
   };

   Map<String, String> body = {"username": "56808453" , "password": "lgm30RNM", "_eventId": "submit", "execution": execution };

   final data = convert.jsonEncode(body);
   //final request = Uri.encodeComponent(body);

   final res = await http.post(url, body: body, headers: header ,encoding: convert.Encoding.getByName('utf-8'));
   //print(res.headers['set-cookie']);
   final my = res.headers['location'].toString();
   final getAuth = await http.post(my, headers: header);

   final cas_mod_auth = getAuth.headers['set-cookie'].substring(0,45);


     setState(() {
       all_access = cas_mod_auth;
     });
   print(cas_mod_auth);

  }


  getResults(BuildContext context) async {

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
          'Cookie': all_access.toString(),
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
                      text: 'Login',
                      onPressed: _isLoading ? null : () => getCookie(context),

                    ),
                    SizedBox(height: 10.0,),
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
            );
          },
        );


      },
    );
  }
}