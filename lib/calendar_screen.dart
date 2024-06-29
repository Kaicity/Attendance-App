import 'package:attendance_app/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFFEEF444C);

  String checkIn = "--/--";
  String checkOut = "--/--";

  String monthPicked = DateFormat('MMMM').format(DateTime.now());

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
              "My Attendance",
              style:
                  TextStyle(fontFamily: "NexaBold", fontSize: screenWidth / 18),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 32,
                ),
                child: Text(
                  monthPicked,
                  style: TextStyle(
                    fontFamily: "NexaBold",
                    fontSize: MediaQuery.of(context).size.width / 18,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: GestureDetector(
                      onTap: () async {
                        final month = await showMonthPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2099),
                          headerColor: primary,
                          selectedMonthBackgroundColor: primary,
                          selectedMonthTextColor: Colors.white,
                          currentMonthTextColor: Colors.green,
                        );

                        if (month != null) {
                          setState(() {
                            monthPicked = DateFormat('MMMM').format(month);
                          });
                        }
                      },
                      child: Text(
                        "Pick a Month",
                        style: TextStyle(
                            fontFamily: "NexaBold", fontSize: screenWidth / 18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 26),
                    child: Icon(
                      Icons.calendar_month,
                      color: primary,
                      size: screenWidth / 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: screenHeight / 1.45,
            child: StreamBuilder<QuerySnapshot>(
              //Lay data tu firebase
              stream: FirebaseFirestore.instance
                  .collection("Member")
                  .doc(User.id)
                  .collection("Record")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  //Chuyen doi data de truy xuat duoc data
                  final snap = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: snap.length,
                      itemBuilder: (context, index) {
                        //Filter danh sach theo thang duoc chon
                        return DateFormat('MMMM')
                                    .format(snap[index]['date'].toDate()) ==
                                monthPicked
                            ? Container(
                                margin: EdgeInsets.only(
                                    top: index > 0 ? 12 : 0, left: 6, right: 6),
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
                                        margin: const EdgeInsets.only(),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: primary,
                                        ),
                                        child: Center(
                                          child: Text(
                                            DateFormat('EE\ndd').format(
                                                snap[index]['date'].toDate()),
                                            style: TextStyle(
                                              fontSize: screenWidth / 18,
                                              fontFamily: 'NexaRegular',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Check In",
                                            style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 28,
                                                color: Colors.black54),
                                          ),
                                          Text(
                                            snap[index]['checkIn'],
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 22,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Check Out",
                                            style: TextStyle(
                                                fontFamily: "NexaRegular",
                                                fontSize: screenWidth / 28,
                                                color: Colors.black54),
                                          ),
                                          Text(
                                            snap[index]['checkOut'],
                                            style: TextStyle(
                                              fontFamily: "NexaBold",
                                              fontSize: screenWidth / 22,
                                              color: snap[index]['checkOut'] == '--/--' ? primary : Colors.black
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox();
                      });
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    ));
  }
}
