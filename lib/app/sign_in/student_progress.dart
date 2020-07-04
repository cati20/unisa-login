import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unisa/services/unisa_login.dart';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http ;
import 'package:progress_indicators/progress_indicators.dart';


class Student_progress extends StatefulWidget  {





  @override
  _Student_progressState createState() => _Student_progressState();
}

class _Student_progressState extends State<Student_progress> {

  String studenNumber;
  String title;
  String studenttNames;
  String qualificatin;
  String registered;
  List modules;
  String totalModules;
  String totalPassedModules;
  String averagePercentage;
  bool isloading = false;
  bool checked = false;
  bool failed = false;

  TextEditingController studentNumberController = TextEditingController();




  Future<void> studentInfo(BuildContext context) async {

    final token = Provider.of<Token>(context);
    final cookie =token.cookie.toString();
    final studentNumber = checked ? studentNumberController.text :  token.student;
    


    setState(() {
      isloading = true;
    });

    final referer = 'https://myadmin.unisa.ac.za/student/portal/add-final-year-modules-app/add';
    final header = {
      'Referer': referer,
      'Content-Type': 'application/json',
      'Accept' : 'application/json',
      'Cookie': cookie
    };


    final url = 'https://myadmin.unisa.ac.za/restricted/myadmin-student-services/services/rest/studentregistrationservice/modules/registrationForm?studentNumber=${studentNumber}&toolName=add-final-year-modules-app';


    final res = await http.get(url,headers: header );



      if ( res.statusCode == 500 ){
        setState(() {
          isloading = false;
          failed = true;
        });

        AlertDialog(title: Text('Error'), content: Text('You are not in the final semester of study and may not apply for additional modules.'));
      }else{

        final status = convert.jsonDecode(res.body);


        setState(() {
          studenNumber = status['studentInfo']['studentNumber'].toString();
          title = status['studentInfo']['title'];
          studenttNames = status['studentInfo']['studentName'];
          qualificatin = status['qualificationInfo']['descriptionInfo'][1]['description'];
          registered = status['academicHistoryInfo']['registeredCredits'].toString();
          modules = status['curriculumModulesInfos'];
          totalModules = status['qualificationSpecialityInfo']['numberOfModules'].toString();
          totalPassedModules = status['academicHistoryInfo']['totalPassedModules'].toString();
          averagePercentage = status['academicHistoryInfo']['averagePercentage'].toString();
          isloading = false;
        });




        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                studenNumber :studenNumber,
                title : title,
                studenttNames :studenttNames,
                qualificatin : qualificatin,
                registered : registered,
                modules : modules,
                totalModules : totalModules,
                totalPassedModules : totalPassedModules,
                averagePercentage : averagePercentage,

              )
          ),
        );
      }




  }//end of studentInfo function


  @override
  void dispose(){
    studentNumberController.dispose();

    super.dispose();
  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Student Progress', style: TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
        centerTitle: true,


      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(

                  children: <Widget>[
                    Text(
                      'Tick to enter a student',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0 ,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Checkbox(
                        value: checked,
                        activeColor: Colors.black,
                        checkColor: Colors.teal,
                        tristate: false,
                        onChanged: (value){
                          setState(() {
                            checked = value;
                          });
                        }
                    )
                  ],
                ),
                SizedBox(height: 100.0,),
                checked == true ?
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Student Number',
                      hintText: '56102548',
                      prefixIcon: Icon(Icons.account_circle, color: Colors.pink,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      focusColor: Colors.lightGreen

                  ),
                  maxLength: 8,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  controller: studentNumberController,
                  keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                  enabled: isloading ? false : true,

                )
                    : SizedBox(),
                SizedBox(
                  height: 200.0,
                  width: 300.0,
                  child: isloading ?
                  Center(

                    child: CollectionScaleTransition(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.bookOpen),
                        Icon(Icons.pageview),
                        Icon(FontAwesomeIcons.solidFile),
                      ],
                    ),
                  )
                      :
                  Container(
                    height: 250.0,
                    child: Image.asset(
                      'images/por.jpeg',
                      fit: BoxFit.cover,
                      height: 200.0,
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                failed ?
                Text(
                  'You are not a final year student',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0 ,
                      fontWeight: FontWeight.w600,
                      color: Colors.black
                  ),
                  textAlign: TextAlign.left,
                )
                :
                RaisedButton(
                  child: Text(
                    'Get Student Progress',
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
        ),
      ),


      backgroundColor: Colors.white70,
    );
  }




}




//////////////////////////////////////////////////////////////////////////



class Profile extends StatefulWidget {
  final title ;
  final studenNumber;
  final studenttNames ;
  final qualificatin;
  final registered;
  final modules;
  final totalModules;
  final totalPassedModules;
  final averagePercentage;


  const Profile({Key key,this.title, this.studenNumber, this.studenttNames, this.qualificatin,  this.registered, this.modules, this.totalModules,
    this.totalPassedModules,this.averagePercentage}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {




  @override
  Widget build(BuildContext context) {
    convertDate (time){
      int date = int.tryParse(time);
      var conveted = new DateTime.fromMicrosecondsSinceEpoch(date * 1000);
      return conveted.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Progress'),
        //Text(widget.profile['studentN'], style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600),),
        elevation: 20.0,
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Student Progress',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 25.0,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),

                color: Colors.black54, //Color(0xffffff4ce),
                elevation: 10.0,

                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      '',
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
                            'Title',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white //Color(0xfffbe9b7b)
                            ),
                          ),
                          widget.title == 'MISS' || widget.title == 'MRS'  ? FaIcon(FontAwesomeIcons.female)
                              : FaIcon(FontAwesomeIcons.male),
                          // //Color(0xfff3c2f2f),),

                          Text(
                            widget.title.toString(),
                            style: TextStyle(
                                fontSize: 15.0,
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
                            'Name',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.personBooth),
                          Text(
                            widget.studenttNames.toString() ,
                            style: TextStyle(
                                fontSize: 12.0,
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
                            'Student No',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(FontAwesomeIcons.user),
                          Text(
                            widget.studenNumber.toString(),
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
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
                elevation: 10.0,
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
                            ' ',
                            style: TextStyle(
                                fontSize: 1.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white //Color(0xfffbe9b7b)
                            ),
                          ),

                          Text(
                            widget.qualificatin,
                            style: TextStyle(
                                fontSize: 12.0,
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
                            'Modules No',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          FaIcon(FontAwesomeIcons.sortNumericUp),

                          Text(
                            widget.totalModules,
                            style: TextStyle(
                                fontSize: 15.0,
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
                            'Completed Modules',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),

                          ),
                          FaIcon(FontAwesomeIcons.sortNumericUp),
                          Text(
                            widget.totalPassedModules,
                            style: TextStyle(
                              fontSize: 15.0,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Text(
                            'Average',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                          ),
                          FaIcon(FontAwesomeIcons.sortNumericUp),
                          Text(
                            widget.averagePercentage +'%',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

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
                            'Registered',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                          ),
                          FaIcon(FontAwesomeIcons.sortNumericUp),
                          Text(
                            widget.registered,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
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
