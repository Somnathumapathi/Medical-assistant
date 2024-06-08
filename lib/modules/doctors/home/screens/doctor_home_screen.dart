import 'package:carousel_slider/carousel_slider.dart';
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
      appBar: AppBar(
        title: Text(
          'Medical Assistant',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CarouselSlider(
                items: [
                  Image.network(
                      'https://www.northwestcareercollege.edu/wp-content/uploads/2022/06/Medical-Assisting-qualification-1.webp'),
                  Image.network(
                      'https://www.careeraddict.com/uploads/article/58344/illustrated-medical_assistant-xrays-doctor.jpg')
                ],
                options: CarouselOptions(
                  autoPlay: true,
                  height: 300,
                  enlargeCenterPage: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: new BoxDecoration(
                    color: const Color.fromARGB(255, 55, 72, 165),
                     borderRadius: new BorderRadius.circular(8.0),
                    
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Doctors using speech-to-text technology instead of writing prescriptions marks a significant advancement in medical practice. This innovation streamlines the prescription process, reducing the time it takes for doctors to document and communicate medication orders. By speaking directly into a device, physicians can quickly and accurately capture patient information, minimizing the risk of errors often associated with illegible handwriting. ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600
                      )
                    ),
                  )),
              ),
              SizedBox(
                 height: 25,
              ),
              Container(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SessionScreen()));
                },
                child: Icon(Icons.add),
              ),
            ),
              Spacer(),
              Container(
                height: 50,
                width: 200,
                margin: EdgeInsets.only(bottom: 20), // Add margin if needed
                child: ElevatedButton(
                  onPressed: () async {
                    await firebaseAuth.signOut();
                    Navigator.popUntil(context, (route) => false);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text('Log out'),
                ),
              ),
            ],
          ),
          
        ],
          )
      );
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