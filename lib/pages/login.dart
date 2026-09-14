// LOGIN
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/home.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/image.png',
                  width: 250,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 5),

              // JUDUL
              Text(
                "Login",
                style: GoogleFonts.dmSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 27, 60, 81),
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Please Sign in to continue.",
                style: TextStyle(color: Color.fromARGB(225, 27, 60, 81)),
              ),

              SizedBox(height: 25),

              // USERNAME
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: "Masukkan Username",
                  labelText: "Username",
                  prefixIcon: Icon(Icons.person),
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 248, 248),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 15),

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: togglePass,
                decoration: InputDecoration(
                  hintText: "Masukkan Password",
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  filled: true,
                  fillColor: Color.fromARGB(255, 248, 248, 248),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        togglePass = !togglePass;
                      });
                    },
                    icon: Icon(
                      togglePass ? Icons.visibility_off : Icons.visibility,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 5),

              // CHECKBOX
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Remeinder me nextime",
                    style: TextStyle(fontSize: 14, color: Color(0xff333333)),
                  ),
                  Transform.scale(
                    scale: .65,
                    child: Switch(
                      value: rememberMe,
                      activeColor: Color.fromARGB(255, 214, 208, 208),
                      activeTrackColor: Color.fromARGB(255, 0, 0, 0),
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              // BUTTON
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      "/home",
                      arguments: {"nama": usernameController.text},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff1D4055),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text("Sign In", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 5),

              // BAWAH BUTTON
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account? ",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        "/home",
                        arguments: {"nama": "ghinaa", "umur": 18},
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
