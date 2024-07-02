import 'dart:io';

import 'package:attendance_app/model/User.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

  String birth = "あなたの誕生日";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${memberId.toLowerCase()}_profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) {
      setState(() {
        User.profilePicLink = value;
      });
    });

    print(User.profilePicLink + "?????");
  }

  @override
  void initState() {
    _getUserId();
    _getCredentials();
  }

  void _getCredentials() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("Member")
        .doc(memberId)
        .get();

    setState(() {
      User.canEdit = doc['canEdit'];
      User.firstname = doc['firsName'];
      User.lastName = doc['lastName'];
      User.birthday = doc['birthDate'];
      User.address = doc['address'];
    });
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
                  GestureDetector(
                    onTap: () {
                      pickUploadProfilePic();
                    },
                    child: Align(
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
                                imageUrl: User.profilePicLink == " "
                                    ? "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small_2x/default-avatar-icon-of-social-media-user-vector.jpg"
                                    : User.profilePicLink,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
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
            customFieldInformation("あなたの名", firstNameController),
            customFieldInformation("あなたの姓", lastNameController),
            // customFieldInformation("あなたの誕生日"),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                setState(() {
                  birth = DateFormat("MM/dd/yyyy").format(pickedDate!);
                });
              },
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
                child: AbsorbPointer(
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    obscureText: false,
                    enabled: false,
                    // Disable text input
                    decoration: InputDecoration(
                      labelText: birth,
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
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                      suffixIcon: const Icon(
                          Icons.calendar_today), // Thêm icon date ở đây
                    ),
                    style: const TextStyle(
                      fontFamily: 'NexaBold',
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
            customFieldInformation("あなたの電話", addressController),

            GestureDetector(
              onTap: () async {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String birthDate = birth;
                String address = addressController.text;

                if (User.canEdit) {
                  if (firstName.isEmpty) {
                    showSnackBar("お名前を入力してください!");
                  } else if (lastName.isEmpty) {
                    showSnackBar("あなたの姓を入力!");
                  } else if (birthDate.isEmpty) {
                    showSnackBar("生年月日を入力してください!");
                  } else if (address.isEmpty) {
                    showSnackBar("住所を入力してください");
                  } else {
                    await FirebaseFirestore.instance
                        .collection("Member")
                        .doc(memberId)
                        .update({
                      'firstName': firstName,
                      'lastName': lastName,
                      'birthDate': birthDate,
                      'address': address,
                      'canEdit': false,
                    });
                  }
                } else {
                  showSnackBar("編集できなくなりました。サポート チームにお問い合わせください。");
                }
              },
              child: Padding(
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
            ),
            Builder(builder: (BuildContext innerContext) {
              return GestureDetector(
                onTap: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
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
            }),
          ],
        ),
      ),
    );
  }

  //Input
  Widget customFieldInformation(
      String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 16, 20, 16),
      child: TextFormField(
        controller: controller,
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
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
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

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}
