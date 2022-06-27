

import 'package:flutter/material.dart';
import 'package:flutter_app/models/user_data_model.dart';
import 'package:flutter_app/repository/data_repository.dart';


// ignore: must_be_immutable
class AddDataDialog extends StatefulWidget {
  UserData? userData;
  AddDataDialog( {this.userData,Key? key}) : super(key: key);

  @override
  _AddDataDialogState createState() => _AddDataDialogState();
}

class _AddDataDialogState extends State<AddDataDialog> {
  String custName = "";
  String gender = 'M';
  double? weight;
  late TextEditingController nameController;
  late TextEditingController weightController;
  final DataRepository repository = DataRepository();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData?.name ?? '');
    weightController = TextEditingController(text: widget.userData?.weight.toString() ?? '');
    gender = widget.userData?.gender ?? 'M';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter customer Name'),
                onChanged: (text) => custName = text,
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: weightController,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter customer Weight'),
                onChanged: (text) => weight = double.tryParse(text) ?? 0.0,
              ),
              RadioListTile(
                title: const Text('Male'),
                value: 'M',
                groupValue: gender,
                selected: gender == 'M' ? true : false,
                onChanged: (value) {
                  setState(() {
                    gender = (value ?? '') as String;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Female'),
                value: 'F',
                selected: gender == 'F' ? true : false,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = (value ?? '') as String;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Other'),
                value: 'O',
                selected: gender == 'O' ? true : false,
                groupValue: gender,
                onChanged: (value) {
                  setState(() {
                    gender = (value ?? '') as String;
                  });
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                if (custName.isNotEmpty && weight != null) {
                  final userData =
                      UserData(custName,gender,weight ?? 0.0,date: DateTime.now());
                  repository.addUserData(userData);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add')),
        ]);
  }
}
