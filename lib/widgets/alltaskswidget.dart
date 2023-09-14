import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/screens/detailscreen.dart';

class AllTaskWidget extends StatefulWidget {
  const AllTaskWidget({super.key});

  @override
  State<AllTaskWidget> createState() => _AllTaskWidgetState();
}

class _AllTaskWidgetState extends State<AllTaskWidget> {
  final currentUser = FirebaseAuth.instance.currentUser!.email;
  final Map<int, MaterialColor> taskheaderColor = {
    0: Colors.red,
    1: Colors.amber,
    2: Colors.green
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          "All Tasks",
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
                          return element["owner"] == currentUser ||
                              element["coowner"].contains(currentUser);
                        }).toList();
                        //print(tasklists);
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
