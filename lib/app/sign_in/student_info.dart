import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unisa/app/sign_in/time_table.dart';
import 'package:unisa/services/unisa_login.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;

import 'Home_page.dart';
import 'academic_record.dart';


class Student_info extends StatefulWidget  {





  @override
  _Student_infoState createState() => _Student_infoState();
}

class _Student_infoState extends State<Student_info> {

  String title;
  String initials;
  String surname;
  String firstNames;
  String gender;
  String birthDate;
  String nationality;
  String homeLanguageDescription;
  String regRegionDescription;
  String qualificationCode;
  String examCentreDescription;
  String amountFinalBalance;
  String year;
  String courierContactNumber;
  String emailAddress;
  String addressLine1;
  String addressLine2;
  String postalCode;
  bool isloading = false;



  Future<void> studentInfo(BuildContext context) async {

    final token = Provider.of<Token>(context);
    final cookie =token.cookie.toString();
    final studentNumber =  token.student;

   setState(() {
     isloading = true;
   });

    final referer = 'https://myadmin.unisa.ac.za/student/portal/exam-results-app/search';
    final header = {
      'Referer': referer,
      'Content-Type': 'application/json',
      'Accept' : 'application/json',
      'Cookie': cookie
    };


    final url = 'https://myadmin.unisa.ac.za/myadmin-financial-services/services/rest/financialservice/accountstatement?studentId=${studentNumber}&accountClassification=SF&toolName=financial-details-app';
    final registr = 'https://myadmin.unisa.ac.za/restricted-myadmin-student-services/services/rest/studentregistrationservice/student?studentNumber=${studentNumber}';
    final address = 'https://myadmin.unisa.ac.za/myadmin-biographic-services/services/rest/addressservice/address?reference=${studentNumber}&type=PHYSICAL&category=1&toolName=biographic-detail-app';
    final phone = 'https://myadmin.unisa.ac.za/myadmin-biographic-services/services/rest/contactservice/contact?reference=${studentNumber}&type=1&toolName=biographic-detail-app';
    final bio = 'https://myadmin.unisa.ac.za/myadmin-biographic-services/services/rest/biographicservice/biographic/${studentNumber}?toolName=biographic-detail-app';

   final res = await http.get(url,headers: header );
  final respo = await http.get(registr,headers: header);
   final re = await http.get(phone, headers: header);
   final adrr = await http.get(address, headers: header);
   final biogra = await http.get(bio, headers: header);

   final fina = convert.jsonDecode(res.body);
   final prodata = convert.jsonDecode(re.body);
   final pro = convert.jsonDecode(respo.body);
   final data = convert.jsonDecode(adrr.body);
   final bigraphy = convert.jsonDecode(biogra.body);







    setState(() {
     title = pro['title'];
      initials =  pro['initials'];
      surname = pro['surname'];
      firstNames = pro['firstNames'];
      gender = pro['gender'];
      birthDate = pro['birthDate'];
      nationality = pro['nationality'];
      homeLanguageDescription = bigraphy['homeLanguageDescription'];
      regRegionDescription = bigraphy['regRegionDescription'];
      qualificationCode = pro['qualificationCode'];
      examCentreDescription = bigraphy[''];
      amountFinalBalance = fina['amountFinalBalance'].toString();
      year = fina['year'].toString();
      courierContactNumber = prodata['courierContactNumber'];
      emailAddress = prodata['emailAddress'];
      addressLine1 = data['addressLine1'];
      addressLine2 = data['addressLine2'];
      postalCode = data['postalCode'];
      isloading = false;
    });



    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(
                  title: title,
              initials: initials,
              surname: surname,
              firstNames: firstNames,
              gender: gender,
              birthDate: birthDate,
              nationality: nationality,
              homeLanguageDescription: homeLanguageDescription,
              regRegionDescription: regRegionDescription,
              qualificationCode: qualificationCode,
              examCentreDescription: examCentreDescription,
              amountFinalBalance: amountFinalBalance,
              year: year,
              courierContactNumber: courierContactNumber,
              emailAddress: emailAddress,
              addressLine1: addressLine1,
              addressLine2: addressLine2,
              postalCode: postalCode,
            )
        )
    );

  }//end of studentInfo function







  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info', style: TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        centerTitle: true,

      ),

      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Get Profile',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: Colors.white
                ),
              ),
              color: Colors.teal, 
              onPressed: isloading == false ? () => studentInfo(context) : null,
            ),
          ],
        ),
      ),


      backgroundColor: Colors.grey,
    );
  }




}




//////////////////////////////////////////////////////////////////////////



class Profile extends StatefulWidget {
  final title ;
  final initials ;
  final surname ;
  final firstNames ;
  final gender ;
  final birthDate ;
  final nationality ;
  final homeLanguageDescription ;
  final regRegionDescription ;
  final qualificationCode ;
  final examCentreDescription ;
  final amountFinalBalance ;
  final year ;
  final courierContactNumber ;
  final emailAddress ;
  final addressLine1 ;
  final addressLine2 ;
  final postalCode ;



  const Profile({Key key,this.title, this.initials, this.surname, this.firstNames, this.gender, this.birthDate, this.nationality, this.homeLanguageDescription,
  this.regRegionDescription,this.qualificationCode, this.examCentreDescription, this.amountFinalBalance, this.year, this.courierContactNumber, this.emailAddress
  ,this.addressLine1, this.addressLine2, this.postalCode}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {




  @override
  Widget build(BuildContext context) {
    convertDate (time){
      var conveted = new DateTime.fromMicrosecondsSinceEpoch(time * 1000);
      return conveted.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Student info'),
        //Text(widget.profile['studentN'], style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),),
        elevation: 10.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Student Profile',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35.0,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0,),
              Text(
                '',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35.0,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0,),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                color: Colors.black54, //Color(0xffffff4ce),
                elevation: 80.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      '', // widget.details['resultTypeDescription'],
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Final Mark',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white //Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black),
                          // //Color(0xfff3c2f2f),),

                          Text(
                            '', //widget.details['mark'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Icon(Icons.perm_identity, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['studentNumber'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Year',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['academicYear'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Exam Date',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),
                          Text(
                            '',
                            //convertDate(widget.details['examDate']).substring(0,10) ,//widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),


                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            '',
                            //widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),


                        ],
                      ),
                    ),

                  ],
                ),


              ),


              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                color: Colors.black54, //Color(0xffffff4ce),
                elevation: 80.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      '', // widget.details['resultTypeDescription'],
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Final Mark',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white //Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black),
                          // //Color(0xfff3c2f2f),),

                          Text(
                            '', //widget.details['mark'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Icon(Icons.perm_identity, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['studentNumber'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Year',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['academicYear'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Exam Date',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),
                          Text(
                            '',
                            //convertDate(widget.details['examDate']).substring(0,10) ,//widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            '',
                            //widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),

                        ],
                      ),
                    ),

                  ],
                ),


              ),

              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                color: Colors.black54, //Color(0xffffff4ce),
                elevation: 80.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      '', // widget.details['resultTypeDescription'],
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Final Mark',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white //Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black),
                          // //Color(0xfff3c2f2f),),

                          Text(
                            '', //widget.details['mark'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Icon(Icons.perm_identity, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['studentNumber'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Year',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),

                          Text(
                            '', //widget.details['academicYear'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Exam Date',
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),
                          Icon(Icons.calendar_today, size: 35.0, color: Colors
                              .black87),
                          Text(
                            '',
                            //convertDate(widget.details['examDate']).substring(0,10) ,//widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),


                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            '',
                            //widget.details['studyUnitDescription'].toString() ,
                            style: TextStyle(
                              fontSize: 19.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),


                        ],
                      ),
                    ),

                  ],
                ),


              ),


            ],
          ),
        ),


      ),
      backgroundColor: Colors.grey[200],
    );
  }
}