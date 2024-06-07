import 'package:flutter/material.dart';
import 'package:medical_assistant/modules/doctors/session/screens/session_screen.dart';

import '../../../../commons/constants.dart';
import '../../../auth/screens/login_screen.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
            child: ElevatedButton(
                onPressed: () async {
                  await firebaseAuth.signOut();
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Log out'))),
        // bottomNavigationBar: ,
        floatingActionButton: FloatingActionButton(onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SessionScreen()));
        }));
  }
}

// import 'package:medical_assistant/modules/auth/screens/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:medical_assistant/modules/auth/screens/login_screen.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   String? uid;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               await firebaseAuth.signOut();
//               Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginScreen("hello")),
//                   (route) => false);
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Text(uid!),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     uid = firebaseAuth.currentUser!.uid;
//   }
// }