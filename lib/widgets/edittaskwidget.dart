import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:lazyterminator/dbmodel.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({required this.id, required this.data, super.key});
  final String id;
  final Map<String, dynamic> data;

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  //Connect Firebase
  final db = FirebaseFirestore.instance.collection('tasks');
  final String? currentUser = FirebaseAuth.instance.currentUser!.email;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  Timestamp? _startDate;
  final TextEditingController _finishDateController = TextEditingController();
  final TextEditingController _finishTimeController = TextEditingController();
  Timestamp? _finishDate;

  Future<void> _selectStartDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _startDateController.text = _picked.toString();
      });
    }
  }

  Future<TimeOfDay?> _selectStartTime() async {
    TimeOfDay? _picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_picked != null) {
      setState(() {
        _startTimeController.text = _picked.format(context);
      });
    }
    return _picked;
  }

  Future<void> _selectFinishDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        _finishDateController.text = _picked.toString();
      });
    }
  }

  Future<TimeOfDay?> _selectFinishTime() async {
    TimeOfDay? _picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_picked != null) {
      setState(() {
        _finishTimeController.text = _picked.format(context);
      });
    }
    return _picked;
  }

  void prefilled() {
    setState(() {
      _nameController.text = widget.data["name"];
      _descriptionController.text = widget.data["description"];
      _startDateController.text =
          widget.data["date_started"].toDate().toString();
      _finishDateController.text =
          widget.data["date_finished"].toDate().toString();
    });
  }

  void updateTask() {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _startDateController.text.isEmpty ||
        _startTimeController.text.isEmpty ||
        _finishDateController.text.isEmpty ||
        _finishTimeController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: const Text("Error"),
                content:
                    const Text("Please fill all the fields before submitting"),
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
      List<String> datecsp = _startDateController.text.split(" ");
      List<String> datefsp = _finishDateController.text.split(" ");
      List<String> timecsp = _startTimeController.text.split(':');
      int st_hours = int.parse(timecsp[0]);
      int st_minutes = int.parse(timecsp[1].split(' ')[0]);
      List<String> timefsp = _startTimeController.text.split(':');
      int fi_hours = int.parse(timefsp[0]);
      int fi_minutes = int.parse(timefsp[1].split(' ')[0]);
      if (timecsp.contains('PM')) {
        st_hours += 12;
      }
      if (timefsp.contains('PM')) {
        fi_hours += 12;
      }
      _startDate = Timestamp.fromDate(DateTime.parse(datecsp[0])
          .add(Duration(hours: st_hours, minutes: st_minutes)));
      _finishDate = Timestamp.fromDate(DateTime.parse(datefsp[0])
          .add(Duration(hours: fi_hours, minutes: fi_minutes)));

      Map<String, dynamic> task = {
        "name": _nameController.text,
        "description": _descriptionController.text,
        "owner": currentUser,
        "coowner": widget.data["coowner"],
        "date_started": _startDate,
        "date_finished": _finishDate,
        "status": widget.data["status"]
      };

      db.doc(widget.id).update(task);
      clearField();
      Navigator.pop(context);
    }
  }

  void clearField() {
    _nameController.clear();
    _descriptionController.clear();
    _startDateController.clear();
    _startTimeController.clear();
    _finishDateController.clear();
    _finishTimeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    prefilled();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Text(
            "Edit Task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          const SizedBox(height: 10),
          TextField(
            textInputAction: TextInputAction.next,
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task Name',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task Description',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: TextField(
                      controller: _startDateController,
                      decoration: const InputDecoration(
                        labelText: "Start Date",
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectStartDate();
                      })),
              Expanded(
                  child: TextField(
                      controller: _startTimeController,
                      decoration: const InputDecoration(
                        labelText: "Start Time",
                        filled: true,
                        prefixIcon: Icon(Icons.alarm),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectStartTime();
                      })),
              Expanded(
                  child: TextField(
                      controller: _finishDateController,
                      decoration: const InputDecoration(
                        labelText: "Finish Date",
                        filled: true,
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectFinishDate();
                      })),
              Expanded(
                  child: TextField(
                      controller: _finishTimeController,
                      decoration: const InputDecoration(
                        labelText: "Finish Time",
                        filled: true,
                        prefixIcon: Icon(Icons.alarm),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectFinishTime();
                      })),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  updateTask();
                });
              },
              child: const Text("Edit")),
        ],
      ),
    );
  }
}
