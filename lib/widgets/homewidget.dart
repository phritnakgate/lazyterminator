import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/detailscreen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;
  final Map<int, MaterialColor> taskheaderColor = {
    0: Colors.red,
    1: Colors.amber,
    2: Colors.green
  };

  bool isToday(Timestamp timeStamp) {
    timeStamp.toDate();
    bool ret = false;
    if (timeStamp.toDate().day == DateTime.now().day &&
        timeStamp.toDate().month == DateTime.now().month &&
        timeStamp.toDate().year == DateTime.now().year) {
      ret = true;
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "Today Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(height: 10),
        StreamBuilder(
            stream: FirebaseFirestore.instance.collection("tasks").snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final tasklists = snapshot.data!.docs.where((element) {
                          return (element["owner"] == currentUser ||
                                  element["coowner"].contains(currentUser)) &&
                              (isToday(element["date_started"]) ||
                                  isToday(element["date_finished"]) ||
                                  ((DateTime.now()).isAfter(
                                          element["date_started"].toDate())) &&
                                      ((DateTime.now()).isBefore(
                                          element["date_finished"].toDate())));
                        }).toList();
                        //print(tasklists.length);
                        if (tasklists.isEmpty) {
                          return const Center(
                              child: Text("No tasks for today :)"));
                        } else {
                          final data = tasklists[index].data();
                          return Card(
                            child: ListTile(
                              title: Text(
                                data["name"],
                                style: TextStyle(
                                  color: taskheaderColor[data["status"]],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(data["description"]),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_right),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return DetailScreen(
                                          id: tasklists[index].id, data: data);
                                    },
                                  ));
                                },
                              ),
                            ),
                          );
                        }
                      });
            })
      ],
    );
  }
}
