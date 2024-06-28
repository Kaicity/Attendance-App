import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  // final animationsMap = <String, AnimationInfo>{};

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
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEAnu7g0FVyu0MY0KfuQ6TvCFEs42-8RPokg&s',
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
                'Nguyen Minh Thong',
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: screenWidth / 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
              child: Text(
                'Nguyen Minh Thong',
                style: TextStyle(
                    fontFamily: "NexaRegular",
                    fontSize: screenWidth / 24,
                    color: Colors.black54),
              ),
            ),
            customFieldInformation("Your Firstname"),
            customFieldInformation("Your Firstname"),
            customFieldInformation("Your Firstname"),
            customFieldInformation("Your Firstname"),
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
                    "Save",
                    style: TextStyle(
                        fontFamily: 'NexaBold',
                        color: Colors.white,
                        fontSize: screenWidth / 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: screenWidth,
              child: Center(
                child: Text(
                  "Log out",
                  style: TextStyle(
                      fontFamily: 'NexaBold',
                      color: Colors.black54,
                      fontSize: screenWidth / 20),
                ),
              ),
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
}
