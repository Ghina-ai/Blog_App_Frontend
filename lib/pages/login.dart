import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool togglePass = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 20,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  Text(
                    "Welcome Back!",
                    style: GoogleFonts.dmSans(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1B3C51),
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Please sign in to continue.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff71808D),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Username",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: "Enter your username",
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xff71808D),
                      ),
                      filled: true,
                      fillColor: const Color(0xffF7F8F9),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Password",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff333333),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextField(
                    controller: passwordController,
                    obscureText: togglePass,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Color(0xff71808D),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            togglePass = !togglePass;
                          });
                        },
                        icon: Icon(
                          togglePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xff71808D),
                        ),
                      ),
                      filled: true,
                      fillColor: const Color(0xffF7F8F9),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff555555),
                        ),
                      ),
                      Switch(
                        value: rememberMe,
                        activeThumbColor: const Color(0xff1D4055),
                        activeTrackColor: const Color(0xffD8E0E5),
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          "/home",
                          arguments: {
                            "nama": usernameController.text.isEmpty
                                ? "User"
                                : usernameController.text,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1D4055),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff666666),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            "/register",
                          );
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1D4055),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}