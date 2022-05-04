import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'Home.dart';
import 'SignIn.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            //Navigator.of(context).pop();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            // const Text(
            //   "Settings",
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            // ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Change Password"),
            //buildAccountOptionRow(context, "Content settings"),
            //buildAccountOptionRow(context, "Social"),
            buildAccountOptionRow(context, "Language"),
            buildAccountOptionRow(context, "Privacy and Security"),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: const [
                Icon(
                  //Icons.volume_up_outlined,
                  Icons.notifications,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Notifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            // buildNotificationOptionRow("Allow", true),
            // buildNotificationOptionRow("Show Previews", true),
            // buildNotificationOptionRow("Sounds", true),
            buildNotificationOptionRow("Allow"),
            buildNotificationOptionRow("Show Previews"),
            buildNotificationOptionRow("Sounds"),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: OutlineButton(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed out");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  });
                },
                child: const Text("SIGN OUT",
                    style: TextStyle(
                        fontSize: 16,
                        //letterSpacing: 2.2,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Row buildNotificationOptionRow(String title, bool isActive) {
  Row buildNotificationOptionRow(String title) {
    bool isActive = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
                value: isActive,
                // onChanged: (bool newValue) {
                //   setState(() {
                //     isActive = newValue;
                //   });
                // },
                onChanged: (value) {
                  isActive = value;
                  setState(() {
                  });
                })

            // child: ListTile(
            //   trailing: CupertinoSwitch(
            //       value: isActive,
            //       onChanged: (bool val) {
            //         setState(() {
            //           isActive = val;
            //         });
            //       }),
            //   onTap: () {
            //     setState(() {
            //       isActive = !isActive;
            //     });
            //   },
            // )

            // child: LiteRollingSwitch(
            //   value: true,
            //   textOn: "On",
            //   textOff: "Off",
            //   colorOn: Colors.greenAccent,
            //   colorOff: Colors.grey,
            //   iconOn: Icons.done,
            //   iconOff: Icons.notifications_off
            // )
            )
      ],
    );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Option 1"),
                    Text("Option 2"),
                    Text("Option 3"),
                  ],
                ),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
