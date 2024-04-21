// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tumorscan/firebase_options.dart';
import 'package:tumorscan/WelcomePage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAnalytics.instance.logEvent(
    name: 'screen_view',
    parameters: {
      'firebase_screen': 'Home',
      'firebase_screen_class': 'Home',
    },
  );

  runApp(const MyApp());
}

Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.addScope('Email');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

// Future<UserCredential?> signInWithGoogle() async {
//   // Create a new provider
//   GoogleAuthProvider googleProvider = GoogleAuthProvider();

//   googleProvider.addScope('email');
//   googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

//   try {
//     // Trigger the sign-in redirect
//     await FirebaseAuth.instance.signInWithRedirect(googleProvider);

//     // This line will never execute in redirect flow
//     return null;
//   } catch (e) {
//     // Handle errors here, if any
//     print('Error signing in with Google: $e');
//     return null;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TumorScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Set initial theme to dark
      ),
      home: const Scaffold(
        body: DarkGreyBodyWithGreyFooter(),
      ),
      routes: {
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}

class DarkGreyBodyWithGreyFooter extends StatefulWidget {
  const DarkGreyBodyWithGreyFooter({super.key});

  @override
  _DarkGreyBodyWithGreyFooterState createState() =>
      _DarkGreyBodyWithGreyFooterState();
}

class _DarkGreyBodyWithGreyFooterState
    extends State<DarkGreyBodyWithGreyFooter> {
  bool isDarkMode = true; // Keep track of current mode
  Future<void> _redirectToGitHub() async {
    final Uri githubUri = Uri.parse('https://github.com/jaswanth28');

    // Check if the URL can be handled by a browser app
    if (!await canLaunchUrl(githubUri)) {
      throw 'Could not launch ${githubUri.toString()}.';
    }

    await launchUrl(githubUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _redirectTol() async {
    final Uri githubUri =
        Uri.parse('https://www.linkedin.com/in/jaswanthbandi28/');

    // Check if the URL can be handled by a browser app
    if (!await canLaunchUrl(githubUri)) {
      throw 'Could not launch ${githubUri.toString()}.';
    }

    await launchUrl(githubUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: isDarkMode
                    ? const Color(0xFF151515)
                    : Colors.white, // Body background color
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 150.0, bottom: 120),
                  child: Image.asset(
                    isDarkMode
                        ? './assets/Icons/p3.jpeg'
                        : './assets/Icons/p3l.jpeg', // Replace 'your_image.png' with your image path
                    height: 340,
                    width: 260,
                  ),
                ),
              ),
            ),
            Container(
              height: 86.0,
              color: isDarkMode
                  ? const Color.fromARGB(255, 35, 35, 35)
                  : Colors.grey[200], // Footer background color
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: _redirectToGitHub, // Redirect to GitHub
                        child: Image.asset(
                          isDarkMode
                              ? './assets/Icons/gh.png'
                              : './assets/Icons/ghl.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8.0, top: .4),
                      child: GestureDetector(
                        onTap: _redirectTol,
                        child: Image.asset(
                          './assets/Icons/In.png',
                          width: 32.0,
                          height: 32.0,
                        ),
                      ),
                    ),
                    // Add more GestureDetector widgets for more icons
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 16.0,
          left: 16.0,
          child: Text(
            'Tumor Scan',
            style: TextStyle(
              color: isDarkMode
                  ? const Color(0xFFC4C7C5)
                  : const Color(0xFF151515), // Text color based on mode
              fontSize: 20.0,
              fontFamily: 'Google Sans, Helvetica Neue, sans-serif',
              fontWeight: FontWeight.w400,
              height: 1.75,
              letterSpacing: 0,
            ),
          ),
        ),
        Positioned(
          top: 18.0,
          right: 18.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      icon: isDarkMode
                          ? const Icon(Icons.wb_sunny)
                          : const Icon(
                              Icons.brightness_3,
                              color: Color(0xFF151515),
                            ), // Using brightness_3 for moon icon
                      onPressed: () {
                        setState(() {
                          isDarkMode = !isDarkMode; // Toggle mode
                        });
                      },
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Sign in with Google
                          final userCredential = await signInWithGoogle();

                          if (userCredential != null) {
                            // Extract username securely
                            final username = userCredential.user!.displayName ??
                                userCredential.user!.email!.split('@').first;

                            // Navigate to home.dart with username (consider state management)
                            Navigator.pushReplacementNamed(context, '/welcome',
                                arguments: {'username': username});
                          } else {
                            print('Sign in cancelled');
                          }
                        } on Exception catch (e) {
                          // Handle errors gracefully (e.g., display a snackbar)
                          print('Error signing in: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8AB4F8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          // Blue edge color
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF151515),
                          fontSize: 15.0, // Font size in pixels
                          height: 2.0,
                          fontFamily:
                              'Google Sans, Roboto, Helvetica, Arial, sans-serif', // Google Sans font
                          fontWeight: FontWeight.w500, // White color for text
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 150.0,
          right: 150.0,
          child: Image.asset(
            './assets/Icons/p2.jpeg',
            width: 500.0,
            height: 350.0,
          ),
        ),
        Positioned(
          top: 285.0,
          left: 130.0,
          child: Container(
            width: 600.0,
            height: 280.0,
            color: isDarkMode ? const Color(0xFF151515) : Colors.white,
            child: Row(
              // Remove const here if unnecessary
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'Our tool utilizes advanced deep learning models to accurately classify brain tumors from medical images. With a dataset of over 10,000 images spanning various tumor types, including glioma and meningioma, our tool achieves exceptional accuracy and performance. The DenseNet 201 model, in particular, boasts a training accuracy of 99.95% and a validation accuracy of 99.97%, surpassing previous studies. Additionally, we prioritize sensitivity and processing times, ensuring efficient and timely diagnoses. This tool represents a significant advancement in brain tumor detection, offering the potential to save lives through swift and precise intervention.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF151515),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
