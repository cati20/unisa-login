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




    return Scaffold(
      appBar: AppBar(
        title: Text('Academic Details', style: TextStyle(
            fontFamily: 'Montserrat', fontWeight: FontWeight.w600)),
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
                elevation: 80.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0,),
                    Text(
                      widget.details['resultTypeDescription'],
                      style: TextStyle(
                          fontSize:30,
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
                                color: Colors.white//Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black ),// //Color(0xfff3c2f2f),),

                          Text(
                            widget.details['mark'].toString(),
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
                            'Exam Mark',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black87),

                          Text(
                             '', //widget.details['examMark'].toString(),
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
                            'Year Mark',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black87),

                          Text(
                           '', //widget.details['yearMark'].toString(),
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
                          Icon(Icons.school, size: 35.0, color: Colors.black87),

                          Text(
                            widget.details['academicYear'].toString(),
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
                            'Exam Mark Weight',
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 35.0, color: Colors.black87),

                          Text(
                            widget.details['examMarkWeight'].toString() == null ? '' : widget.details['examMarkWeight'].toString(),
                            style: TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),

                          Text(widget.details.toString())

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

