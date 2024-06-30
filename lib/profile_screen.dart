import 'dart:async';

import 'package:attendance_app/home_screen.dart';
import 'package:attendance_app/model/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFFEEF444C);

  String checkIn = "--/--";
  String checkOut = "--/--";

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String memberId = " ";

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    _getUserId();
  }

  void _getUserId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    memberId = sharedPreferences.getString("memberId")!;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              child: Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: 140,
                    decoration: BoxDecoration(
                      color: primary,
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          'https://img.freepik.com/free-photo/japan-background-digital-art_23-2151546185.jpg',
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-1, 1),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 16),
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeOutDuration:
                                  const Duration(milliseconds: 500),
                              imageUrl:
                                  'https://avatars.githubusercontent.com/u/171671384?v=4',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Text(
                'グエン・ミン・トン',
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Text(
                'メンバー: $memberId',
                style: TextStyle(
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 24,
                    color: Colors.black54),
              ),
            ),
            customFieldInformation("あなたの名"),
            customFieldInformation("あなたの姓"),
            customFieldInformation("あなたの誕生日"),
            customFieldInformation("あなたの電話"),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                height: 60,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    "保存",
                    style: TextStyle(
                        fontFamily: 'NexaBold',
                        color: Colors.white,
                        fontSize: screenWidth / 18),
                  ),
                ),
              ),
            ),
            Builder(
              builder: (BuildContext innerContext) {
                return GestureDetector(
                  onTap: () async {
                    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    User.reset();

                    Phoenix.rebirth(innerContext);
                  },
                  child: SizedBox(
                    height: 60,
                    width: screenWidth,
                    child: Center(
                      child: Text(
                        "ログアウト",
                        style: TextStyle(
                            fontFamily: 'NexaBold',
                            color: Colors.black54,
                            fontSize: screenWidth / 20),
                      ),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  //Input
  Widget customFieldInformation(String hintText) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        obscureText: false,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(
            fontFamily: 'NexaRegular',
            color: Colors.black54,
            letterSpacing: 0,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
        style: const TextStyle(
          fontFamily: 'NexaBold',
          letterSpacing: 0,
        ),
      ),
    );
  }
  //code
}
