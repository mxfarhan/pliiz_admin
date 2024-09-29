import 'package:flutter/material.dart';



class VerificationDonePage extends StatefulWidget {
  const VerificationDonePage({Key? key}) : super(key: key);
  @override
  State<VerificationDonePage> createState() => _VerificationDonePageState();
}

class _VerificationDonePageState extends State<VerificationDonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.check,color: Colors.white,size: 40,),),
          const Text("Verification link is send to to you\n Check Your Index",style: TextStyle(
            fontSize: 25,
          ),)
        ],
      ),
    );
  }
}
