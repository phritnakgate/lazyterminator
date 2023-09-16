import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazyterminator/widgets/edittaskwidget.dart';
import 'package:lazyterminator/widgets/focustaskwidget.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.id, required this.data, super.key});

  final Map<String, dynamic> data;
  final String id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _gKey = GlobalKey<ScaffoldState>();
  String bottomSheetState = "CO"; //CO = Co-Owner, ED = Edit Details, FO = Focus

  int startdateh = 0;
  int startdatem = 0;
  int finishdateh = 0;
  int finishdatem = 0;

  void btmSheet() {
    TextEditingController coownerController = TextEditingController();

    _gKey.currentState!.showBottomSheet<void>((BuildContext context) {
      if (bottomSheetState == "CO") {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          height: 200,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const Text(
                  "Add Co-Owner",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                TextField(
                    controller: coownerController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email')),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.id)
                            .update({
                          'coowner':
                              FieldValue.arrayUnion([coownerController.text])
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Add'),
                    ),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    )
                  ],
                )
              ])),
        );
      } else if (bottomSheetState == "ED") {
        return Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child:
              Center(child: EditTaskWidget(id: widget.id, data: widget.data)),
        );
      } else {
        return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: FocusTaskWidget(
              taskhour: finishdateh - startdateh,
              taskminutes: finishdatem - startdatem,
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.email;
    final startDate = widget.data["date_started"].toDate();
    final finishDate = widget.data["date_finished"].toDate();

    final Map<int, TextStyle> taskheaderStyle = {
      0: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.red),
      1: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.amber),
      2: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 30, color: Colors.green)
    };
    //final startTime =
    return Scaffold(
      key: _gKey,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit, color: Color.fromRGBO(23, 15, 106, 1)),
            onPressed: () {
              setState(() {
                bottomSheetState = "ED";
                btmSheet();
              });
            },
          )
        ],
        title: const Text(
          "Task Details",
          style: TextStyle(color: Color.fromRGBO(23, 15, 106, 1)),
        ),
        backgroundColor: const Color.fromRGBO(254, 230, 159, 1),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(widget.data["name"],
                style: taskheaderStyle[widget.data["status"]]),
            const SizedBox(height: 10),
            Text(widget.data["description"],
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Owner",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Co-Owner",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.data["owner"] == currentUser
                    ? const Text("You", style: TextStyle(fontSize: 18))
                    : Text("${widget.data["owner"]}",
                        style: const TextStyle(fontSize: 18)),
                widget.data["coowner"].length == 0
                    ? const Text("None", style: TextStyle(fontSize: 18))
                    : widget.data["coowner"].contains(currentUser)
                        ? Text("You and ${widget.data["coowner"]}",
                            style: const TextStyle(fontSize: 18))
                        : Text("${widget.data["coowner"]}",
                            style: const TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                    "Start: ${startDate.day}/${startDate.month}/${startDate.year}",
                    style: const TextStyle(fontSize: 18)),
                Text(
                    "End: ${finishDate.day}/${finishDate.month}/${finishDate.year}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("${startDate.hour}:${startDate.minute}",
                    style: const TextStyle(fontSize: 18)),
                Text("${finishDate.hour}:${finishDate.minute}",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            !DateTime.now().difference(finishDate).isNegative
                ? const Text("Past Due!!!",
                    style: TextStyle(fontSize: 18, color: Colors.red))
                : const Text(""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.id)
                          .update({'status': 0});
                      setState(() {});
                    },
                    child: const Text("Unstarted")),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.id)
                          .update({'status': 1});
                      setState(() {});
                    },
                    child: const Text("In Progress")),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(widget.id)
                          .update({'status': 2});
                      setState(() {});
                    },
                    child: const Text("Done"))
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    bottomSheetState = "CO";
                    btmSheet();
                  });
                },
                child: const Text("Add Co-Owner")),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  startdateh = startDate.hour;
                  startdatem = startDate.minute;
                  finishdateh = finishDate.hour;
                  finishdatem = finishDate.minute;
                  if (startdateh > finishdateh ||
                      (startdateh == finishdateh &&
                          startdatem >= finishdatem) ||
                      finishdateh - startdateh > 3 ||
                      startDate.day != finishDate.day) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text("Error"),
                              content: const Text(
                                  "This task is not possible use focus mode."),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"),
                                )
                              ]);
                        });
                  } else {
                    setState(() {
                      bottomSheetState = "FO";
                      btmSheet();
                    });
                  }
                },
                child: const Text("Focus this task")),
          ],
        ),
      ),
    );
  }
}
