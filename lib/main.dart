import 'package:camera/camera.dart';
import 'package:disapp/home.dart';
import 'package:disapp/login.dart';
import 'package:disapp/pages/camerap.dart';
import 'package:disapp/pages/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; 

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  cameras = await availableCameras();
  await Firebase.initializeApp( 
      options: const FirebaseOptions( 
             // these are variable  
          // for each firebase project 
          apiKey: "AIzaSyBCfabzkTqHPUeh8zea1eDW5iaVZn5Kb1w",
        authDomain: "chatapp-22c76.firebaseapp.com",
        projectId: "chatapp-22c76",
        storageBucket: "chatapp-22c76.appspot.com",
        messagingSenderId: "731016832999",
        appId: "1:731016832999:web:92074eb70ca7db21a5bf42",
        measurementId: "G-LL9BYZFVNP"
  )); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const loginscreenpage(),
    );
  }
}

