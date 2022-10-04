//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:chatapp/Calling/voice_calling/call_methods.dart';
import 'package:chatapp/Calling/voice_calling/pickup_screen.dart';
import 'package:chatapp/Calling/voice_calling/user_provider.dart';
import 'package:chatapp/Screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'call.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    // ignore: unnecessary_null_comparison
    return (userProvider != null && userProvider.getUser != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: callMethods.callStream(phone: userProvider.getUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.data() != null) {
                Call call = Call.fromMap(
                    snapshot.data!.data() as Map<dynamic, dynamic>);
                if (!call.hasDialled!) {
                  return PickupScreen(
                    call: call,
                    currentuseruid: userProvider.getUser!.uid,
                  );
                }
              }
              return scaffold;
            },
          )
        : SplashScreen();
  }
}
