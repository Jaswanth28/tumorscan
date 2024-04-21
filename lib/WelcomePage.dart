// ignore_for_file: unnecessary_string_interpolations, avoid_print, library_private_types_in_public_api, avoid_web_libraries_in_flutter, unused_import, file_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_web/image_picker_web.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool isDarkMode = true;
  Image? _pickedImage;
  Uint8List? _byteImage;
  String? _resultText; // Added to store the result text
  bool showPredictButton = false;

  void toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> _pickImage() async {
    final fromPicker1 = await ImagePickerWeb.getImageAsBytes();
    if (fromPicker1 != null) {
      final imageWidget = Image.memory(fromPicker1);
      setState(() {
        _pickedImage = imageWidget;
        _byteImage = fromPicker1;
        showPredictButton = true;
        _resultText = null; // Clear result text when a new image is picked
      });
    }
  }

  void _clearImage() {
    setState(() {
      _pickedImage = null;
      showPredictButton = false;
      _byteImage = null;
      _resultText = null; // Clear result text when image is cleared
    });
  }

  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/');
  }
// for flask
  // Future<void> sendImageToEndpoint(
  //     Uint8List imageBytes, String? username) async {
  //   var uri = Uri.parse('http://127.0.0.1:2000/upload');
  //   var request = http.MultipartRequest('POST', uri);
  //   if (username != null) {
  //     request.fields['username'] = username;
  //   }
  //   request.files.add(
  //     http.MultipartFile.fromBytes(
  //       'image',
  //       imageBytes,
  //       filename: 'image.jpg',
  //     ),
  //   );

  //   try {
  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       final responseBody = await response.stream.bytesToString();
  //       print(responseBody);
  //       setState(() {
  //         _resultText = responseBody
  //             .replaceAll('"', '')
  //             .replaceAll('{', '')
  //             .replaceAll('}', '')
  //             .replaceAll('predicted_class:', '')
  //             .toUpperCase();
  //       });
  //       print(responseBody);
  //     } else {
  //       setState(() {
  //         _resultText =
  //             'Failed to send image. Status code: ${response.statusCode}';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _resultText = 'Error: $e';
  //     });
  //   }
  // }
  // for fastapi
  Future<void> sendImageToEndpoint(
      Uint8List imageBytes, String? username) async {
    var uri = Uri.parse('http://127.0.0.1:2000/upload');
    var request = http.MultipartRequest('POST', uri);

    if (username != null) {
      request.fields['username'] = username;
    }

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'image.jpg',
      ),
    );

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final parsedResponse = jsonDecode(responseBody);
        final predictedClass = parsedResponse['predicted_class'];
        setState(() {
          _resultText = predictedClass.toUpperCase();
        });
      } else {
        setState(() {
          _resultText =
              'Failed to send image. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _resultText = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final username = arguments?['username'] as String?;
    if (username == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF151515) : Colors.white10,
      body: Stack(
        children: [
          Positioned(
            left: 50,
            top: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Your existing code for displaying image and buttons
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDarkMode
                            ? const Color.fromARGB(255, 217, 217, 217)
                            : const Color(0xFF151515),
                        width: 1.5, // Adjust border width as needed
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: _pickedImage != null
                          ? SizedBox(
                              height: 350,
                              width: 500,
                              child: _pickedImage!,
                            )
                          : Image.asset(
                              './assets/Icons/i.jpeg',
                              fit: BoxFit.cover,
                              width: 500,
                              height: 350,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                    height: 40), // Adding space between image and buttons
                Row(
                  children: [
                    if (!showPredictButton) // Show browse button if Predict button is not shown
                      ElevatedButton(
                        onPressed: () {
                          _pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8AB4F8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 27.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: const Text(
                          'Browse',
                          style: TextStyle(
                            color: Color(0xFF151515),
                            fontSize: 15.0,
                            fontFamily:
                                'Google Sans, Roboto, Helvetica, Arial, sans-serif',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                    if (_pickedImage !=
                        null) // Show Predict button if image is picked
                      ElevatedButton(
                        onPressed: () {
                          if (_pickedImage != null) {
                            final imageBytes = _byteImage;
                            if (imageBytes != null) {
                              sendImageToEndpoint(imageBytes, '$username');
                            } else {
                              print("Error: Byte image is null.");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 27.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        child: const Text(
                          'Predicted',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontFamily:
                                'Google Sans, Roboto, Helvetica, Arial, sans-serif',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.25,
                          ),
                        ),
                      ),
                    const SizedBox(width: 300),
                    ElevatedButton(
                      onPressed: () {
                        _clearImage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 254, 92, 92),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 27.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFF151515),
                          fontSize: 15.0,
                          fontFamily:
                              'Google Sans, Roboto, Helvetica, Arial, sans-serif',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                username != null ? '$username' : '',
                style: TextStyle(
                  color: isDarkMode
                      ? const Color.fromARGB(255, 217, 217, 217)
                      : const Color(0xFF151515),
                  fontSize: 20.0,
                  fontFamily: 'Google Sans, Helvetica Neue, sans-serif',
                  fontWeight: FontWeight.w400,
                  height: 1.75,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
          Positioned(
              top: 18.0,
              right: 66.0 +
                  54.0 +
                  8.0, // 48.0 is icon button size, 8.0 is spacing between buttons
              child: IconButton(
                icon: Icon(
                  isDarkMode ? Icons.history_sharp : Icons.history_sharp,
                  color: isDarkMode
                      ? const Color.fromARGB(255, 217, 217, 217)
                      : const Color(0xFF151515),
                ),
                onPressed: () => {},
              )),
          Positioned(
            top: 18.0,
            right: 18.0 +
                48.0 +
                8.0, // 48.0 is icon button size, 8.0 is spacing between buttons
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.brightness_3,
                color: isDarkMode
                    ? const Color.fromARGB(255, 217, 217, 217)
                    : const Color(0xFF151515),
              ),
              onPressed: toggleDarkMode,
            ),
          ),
          Positioned(
            top: 18.0,
            right: 18.0,
            child: IconButton(
              icon: Icon(
                Icons.logout,
                color: isDarkMode
                    ? const Color.fromARGB(255, 217, 217, 217)
                    : const Color(0xFF151515),
              ),
              onPressed: () => logout(context),
            ),
          ),
          Positioned(
            left: 1000, // Adjust left position according to your preference
            top: 150, // Adjust top position according to your preference
            child: Text(
              _resultText ?? '', // Display result text here
              style: TextStyle(
                color: isDarkMode
                    ? const Color.fromARGB(255, 217, 217, 217)
                    : const Color(0xFF151515), // Adjust color as needed
                fontSize: 22.0,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
