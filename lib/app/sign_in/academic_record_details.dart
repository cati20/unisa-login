import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class DetailsScreen extends StatefulWidget  {
  const DetailsScreen ({Key key, @required this.details}) : super(key : key);

  final details;


  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text('Results Details', style: TextStyle(
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
                widget.details['course'],
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
                      widget.details['description'],
                      style: TextStyle(
                          fontSize:20,
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
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                              color: Colors.white//Color(0xfffbe9b7b)
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black ),// //Color(0xfff3c2f2f),),

                          Text(
                            widget.details['finalMark'].toString(),
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
                            'Exam Mark',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black87),

                          Text(
                            widget.details['examMark'].toString(),
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
                            'Year Mark',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black87),

                          Text(
                            widget.details['yearMark'].toString(),
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
                            'Year Mark Weight',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black87),

                          Text(
                            widget.details['yearMarkWeight'].toString() == null ? '' : widget.details['yearMarkWeight'].toString(),
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
                            'Exam Mark Weight',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: Colors.white
                            ),
                          ),
                          Icon(Icons.school, size: 20.0, color: Colors.black87),

                          Text(
                            widget.details['examMarkWeight'].toString() == null ? '' : widget.details['examMarkWeight'].toString(),
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
              )

            ],
          ),
        ),
      ),

      backgroundColor: Colors.grey,
    );
  }





}

