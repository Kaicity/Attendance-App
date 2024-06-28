import 'dart:async';

import 'package:attendance_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_to_act/slide_to_act.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({Key? key}) : super(key: key);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFFEEF444C);

  String checkIn = "--/--";
  String checkOut = "--/--";

  @override
  void initState() {
    _getRecord();
  }

  void _getRecord() async {
    try {
      //Query thong tin user check in den firebase
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Member")
          .where('id', isEqualTo: User.username)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Member")
          .doc(snap.docs[0].id)
          .collection("Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkIn = "--/--";
        checkOut = "--/--";
      });
    }
    print(checkIn);
    print(checkOut);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 32,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome",
                style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 20),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Member " + User.username,
                style: TextStyle(
                    fontFamily: "NexaBold", fontSize: screenWidth / 18),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 32,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Status",
                style: TextStyle(
                    fontFamily: "NexaBold", fontSize: screenWidth / 20),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12, bottom: 32),
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check In",
                            style: TextStyle(
                                fontFamily: "NexaRegular",
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(
                            checkIn,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Check Out",
                            style: TextStyle(
                                fontFamily: "NexaRegular",
                                fontSize: screenWidth / 20,
                                color: Colors.black54),
                          ),
                          Text(
                            checkOut,
                            style: TextStyle(
                              fontFamily: "NexaBold",
                              fontSize: screenWidth / 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: DateTime.now().day.toString(),
                    style:
                        TextStyle(color: primary, fontSize: screenWidth / 20),
                    children: [
                      TextSpan(
                        text: DateFormat(' MMMM yyyy')
                            .format(DateTime.now())
                            .toString(),
                        style: TextStyle(
                            fontSize: screenWidth / 20,
                            color: Colors.black,
                            fontFamily: "NexaBold"),
                      ),
                    ]),
              ),
            ),

            //Su dung stream builder nhan biet duoc thoi gian hien tai
            StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      DateFormat('hh:mm:ss a')
                          .format(DateTime.now())
                          .toString(),
                      style: TextStyle(
                          fontFamily: "NexaRegular",
                          fontSize: screenWidth / 20,
                          color: Colors.black54),
                    ),
                  );
                }),

            //Hien thi slider action neu chua check out
            checkOut == '--/--'
                ? Container(
                    margin: EdgeInsets.only(top: 24),
                    child: Builder(builder: (context) {
                      final GlobalKey<SlideActionState> key = GlobalKey();

                      return SlideAction(
                        text: checkIn == "--/--"
                            ? "Slide to Check In"
                            : "Slide to Check Out",
                        textStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: screenWidth / 22,
                            fontFamily: "NexaRegular"),
                        outerColor: Colors.white,
                        innerColor: primary,
                        key: key,
                        onSubmit: () async {
                          // print("Check In " +DateFormat('hh:mm').format(DateTime.now()));

                          //Set timeout trang thai slider action

                          //Query thong tin user check in den firebase
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("Member")
                              .where('id', isEqualTo: User.username)
                              .get();

                          DocumentSnapshot snap2 = await FirebaseFirestore
                              .instance
                              .collection("Member")
                              .doc(snap.docs[0].id)
                              .collection("Record")
                              .doc(DateFormat('dd MMMM yyyy')
                                  .format(DateTime.now()))
                              .get();

                          try {
                            //Neu da checkin thi tien hanh buoc check out
                            String checkIn = snap2['checkIn'];

                            setState(() {
                              checkOut =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });

                            await FirebaseFirestore.instance
                                .collection("Member")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .update({
                              'date': Timestamp.now(),
                              'checkIn': checkIn,
                              'checkOut':
                                  DateFormat('hh:mm').format(DateTime.now())
                            });
                          } catch (e) {
                            setState(() {
                              checkIn =
                                  DateFormat('hh:mm').format(DateTime.now());
                            });
                            //Chua check in thi catch o day
                            await FirebaseFirestore.instance
                                .collection("Member")
                                .doc(snap.docs[0].id)
                                .collection("Record")
                                .doc(DateFormat('dd MMMM yyyy')
                                    .format(DateTime.now()))
                                .set({
                              'date': Timestamp.now(),
                              'checkIn':
                                  DateFormat('hh:mm').format(DateTime.now()),
                              'checkOut': '--/--',
                            });
                          }

                          key.currentState!.reset();
                        },
                      );
                    }),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 32),
                    child: Text(
                      "You have complete today!",
                      style: TextStyle(
                        fontFamily: "NexaRegular",
                        fontSize: screenWidth / 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
            //Da check out hint slider action
          ],
        ),
      ),
    );
  }
}
