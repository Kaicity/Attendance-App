import 'package:attendance_app/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();

  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = const Color(0xFFEEF444C);

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    final bool isKeyBoardVisible =
    KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              isKeyBoardVisible
                  ? const SizedBox(
                height: 5,
              )
                  : Container(
                height: screenHeight / 2.5,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(70)),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: screenWidth / 5,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: screenHeight / 15, bottom: screenHeight / 30),
                child: Text(
                  "Đăng nhập tài khoản",
                  style: TextStyle(
                      fontSize: screenWidth / 18, fontFamily: "NexaBold"),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(horizontal: screenWidth / 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fieldTitle("Thành Viên ID: "),
                    customeField(
                        "Nhập ID của bạn", idController, Icons.person, false),
                    const SizedBox(
                      height: 15,
                    ),
                    fieldTitle("Mật khẩu: "),
                    customeField("Nhập mật khẩu của bạn", passController,
                        Icons.lock, true),
                    GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        String id = idController.text.trim();
                        String password = passController.text.trim();

                        //Kiem tra thong tin dang nhap den Firebase
                        if (id.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                              Text("ID thành viên không được để trống"),
                            ),
                          );
                        } else if (password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Mật khẩu không được để trống"),
                            ),
                          );
                        } else {
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection('Member')
                              .where('id', isEqualTo: id)
                              .get();

                          try {
                            if (password == snap.docs[0]['password']) {
                              //print("Success");
                              sharedPreferences =
                              await SharedPreferences.getInstance();

                              //Luu thong tin memberId
                              sharedPreferences
                                  .setString("memberId", id)
                                  .then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                );
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                      Text("Mật khẩu không chính xác!")));
                            }
                          } catch (e) {
                            String error = " ";

                            if (e.toString() ==
                                "RangeError (index): Invalid value: Valid value range is empty: 0") {
                              setState(() {
                                error = "Thành viên không tồn tại";
                              });
                            } else {
                              setState(() {
                                error = "Có lỗi xảy ra";
                              });
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight / 20),
                        width: screenWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "NexaBold",
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customeField(String hintText, TextEditingController controllerGetValue,
      IconData icon, bool obscure) {
    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth / 8,
            child: Icon(
              icon,
              color: Colors.red,
              size: 25,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 6),
              child: TextFormField(
                controller: controllerGetValue,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hintText,
                ),
                maxLines: 1,
                obscureText: obscure,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
