import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramclone/response/auth.dart';
import 'package:instagramclone/responsive/mobile_screen.dart';
import 'package:instagramclone/screens/sign_up.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/image_picker_utility.dart';
import 'package:instagramclone/widgets/text_form_field.dart';

class LogIn extends StatefulWidget {
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool isemail = false;
  bool ispassword = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String error = await Auth().Login(
        email: _emailController.text, password: _passwordController.text);

    if (error == "success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MobileScreen()));
    } else {
      showSnackBar(context, error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: Theme.of(context).iconTheme.color,
                height: 57,
              ),
              SizedBox(
                height: 25,
              ),
              TextFieldForm(
                textController: _emailController,
                isPass: false,
                hintText: "email",
                textInputType: TextInputType.emailAddress,
                onchanged: (_) {
                  setState(() {
                    isemail = true;
                  });
                },
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldForm(
                textController: _passwordController,
                isPass: true,
                hintText: "Password",
                textInputType: TextInputType.text,
                onchanged: (_) {
                  setState(() {
                    ispassword = true;
                  });
                },
              ),
              SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                        )
                      : Text(
                          'Log in',
                          style: TextStyle(
                              color: (isemail == true && ispassword == true)
                                  ? Colors.white
                                  : Colors.white38,
                              fontWeight: FontWeight.bold),
                        ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: (isemail == true && ispassword == true)
                        ? Colors.blueAccent.shade700
                        : Color(0xff0095f6).withOpacity(0.4),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Flexible(child: Container(), flex: 2),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Don't have an account?",
                          style: TextStyle(color: Colors.grey)),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      ),
                      child: Container(
                        child: const Text(
                          ' Sign up.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
