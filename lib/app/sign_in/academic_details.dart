import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class AcademicDetails extends StatefulWidget  {
  const AcademicDetails ({Key key, @required this.details}) : super(key : key);

  final details;


  @override
  _AcademicDetailsState createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends State<AcademicDetails> {

  @override
  Widget build(BuildContext context) {

      convertDate (time){
        var conveted = new DateTime.fromMicrosecondsSinceEpoch(time * 1000);
        return conveted.toString();
      }



    return Scaffold(
      appBar: AppBar(
        title: Text('Module Details', style: TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
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
                widget.details['qualificationCode'],
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 35.0,
                    color: Colors.black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15.0,),
              Text(
                widget.details['studyUnitCode'],
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
                color: Colors.black54,//Color(0xffffff4ce),
                elevation: 10.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      widget.details['resultTypeDescription'],
                      style: TextStyle(
                          fontSize:20,
                          fontFamily: 'Montserrat',
                          color: Colors.teal
                      ),
                      textAlign: TextAlign.center,
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
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white//Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black ),
                          Text(
                            widget.details['mark'].toString(),
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

                          Icon(Icons.perm_identity, size: 20.0, color: Colors.black87),

                          Text(
                             widget.details['studentNumber'].toString(),
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
                            'Year',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.calendar_today, size: 20.0, color: Colors.black87),

                          Text(
                            widget.details['academicYear'].toString(),
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
                            'Exam Date' ,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,

                            ),
                            softWrap: true,
                          ),
                          Icon(Icons.calendar_today, size: 20.0, color: Colors.black87),
                          Text(
                             convertDate(widget.details['examDate']).substring(0,10) ,//widget.details['studyUnitDescription'].toString() ,
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
                        children: <Widget>[

                          Text(
                            widget.details['studyUnitDescription'].toString() ,
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

                  ],
                ),
              )
            ],
          ),
        ),
      ),

      backgroundColor: Colors.grey,
    );
  }





}

