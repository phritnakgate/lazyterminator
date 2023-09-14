import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({required this.id, required this.data, super.key});

  final Map<String, dynamic> data;
  final String id;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
      appBar: AppBar(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                widget.data["owner"] == currentUser
                    ? const Text("Owner: You", style: TextStyle(fontSize: 18))
                    : Text("Owner: ${widget.data["owner"]}",
                        style: const TextStyle(fontSize: 18)),
                widget.data["coowner"].length == 0
                    ? const Text("Co-owner: None",
                        style: TextStyle(fontSize: 18))
                    : widget.data["coowner"].contains(currentUser)
                        ? Text("Co-owner: You and ${widget.data["coowner"]}",
                            style: const TextStyle(fontSize: 18))
                        : Text("Co-owner: ${widget.data["coowner"]}",
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
            )
          ],
        ),
      ),
    );
  }
}
