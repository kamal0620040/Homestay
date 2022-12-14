import 'dart:typed_data';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:homestay/resources/auth_methods.dart';
import 'package:homestay/screens/home_screen.dart';
import 'package:homestay/screens/login_screen.dart';
import 'package:homestay/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController contactDetail = TextEditingController();
  TextEditingController? communityCOde = TextEditingController();

  Uint8List? _image;
  bool _isLoading = false;
  bool? isOwner = false;

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      file: _image!,
      number: contactDetail.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      // show snackbar
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => const LoginScreen()),
      ),
    );
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    contactDetail.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.only(all: 20.0),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Text field input for email
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        Text(
                          "Create an account",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          "Sign up to continue",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(202, 202, 202, 1),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // circular widget to accept and show our selected file
                        Stack(
                          children: [
                            Center(
                              child: _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : const CircleAvatar(
                                      radius: 64,
                                      backgroundImage: NetworkImage(
                                          "https://i.stack.imgur.com/34AD2.jpg"),
                                    ),
                            ),
                            Positioned(
                              bottom: -10,
                              left: 175,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Name",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: _nameController,
                          hintText: "Enter your name",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Email",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: _emailController,
                          hintText: "Enter your email",
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Text field input for password
                        Text(
                          "Password",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFieldInput(
                          textEditingController: _passwordController,
                          hintText: "Enter your password",
                          textInputType: TextInputType.text,
                          isPass: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Contact Number",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFieldInput(
                              textEditingController: contactDetail,
                              hintText: "Number",
                              textInputType: TextInputType.number,
                              isPass: true,
                            ),
                            // FirebasePhoneAuthHandler(
                            //   phoneNumber: "+9779866365148",
                            //   signOutOnSuccessfulVerification: false,
                            //   linkWithExistingUser: false,
                            //   builder: (context, controller) {
                            //     return SizedBox.shrink();
                            //   },
                            //   onLoginSuccess:
                            //       (userCredential, autoVerified) {
                            //     debugPrint(
                            //         "autoVerified: $autoVerified");
                            //     debugPrint(
                            //         "Login success UID: ${userCredential.user?.uid}");
                            //   },
                            //   onLoginFailed:
                            //       (authException, stackTrace) {
                            //     debugPrint(
                            //         "An error occurred: ${authException.message}");
                            //   },
                            //   onError: (error, stackTrace) {},
                            // ),
                          ],
                        ),
                        CheckboxListTile(
                          title:
                              const Text("Are you from authorized community?"),
                          value: isOwner,
                          onChanged: (newValue) {
                            setState(() {
                              isOwner = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                        isOwner!
                            ? Column(
                                children: [
                                  Text(
                                    "Enter your community code",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldInput(
                                    textEditingController: communityCOde!,
                                    hintText: "Number",
                                    textInputType: TextInputType.number,
                                    isPass: true,
                                  ),
                                  // FirebasePhoneAuthHandler(
                                  //   phoneNumber: "+9779866365148",
                                  //   signOutOnSuccessfulVerification: false,
                                  //   linkWithExistingUser: false,
                                  //   builder: (context, controller) {
                                  //     return SizedBox.shrink();
                                  //   },
                                  //   onLoginSuccess:
                                  //       (userCredential, autoVerified) {
                                  //     debugPrint(
                                  //         "autoVerified: $autoVerified");
                                  //     debugPrint(
                                  //         "Login success UID: ${userCredential.user?.uid}");
                                  //   },
                                  //   onLoginFailed:
                                  //       (authException, stackTrace) {
                                  //     debugPrint(
                                  //         "An error occurred: ${authException.message}");
                                  //   },
                                  //   onError: (error, stackTrace) {},
                                  // ),
                                ],
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        const SizedBox(
                          height: 28,
                        ),
                        //button signup
                        InkWell(
                          onTap: signUpUser,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              color: Color.fromRGBO(101, 146, 233, 1),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Create account",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        //transition for signin
                        Flexible(
                          flex: 1,
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Already have an account?",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: navigateToLogin,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  " Sign In",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(101, 146, 233, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        // Text("Already have an account? Sign In",style: ,),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
