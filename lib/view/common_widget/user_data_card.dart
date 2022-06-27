import 'package:flutter/material.dart';
import 'package:flutter_app/models/user_data_model.dart';
import 'package:flutter_app/utility/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UserDataCard extends StatelessWidget {
  final UserData userData;
  final TextStyle boldStyle;
  final Function(UserData data) onEdit;
  final Function(UserData data) onDelete;
  final splashColor = {
    'M': Colors.blue[100],
    'F': Colors.pink[100],
    'O': Colors.grey[100]
  };

  UserDataCard({Key? key, required this.userData, required this.boldStyle,required this.onEdit,required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key:  ValueKey(userData.referenceId),
      endActionPane: ActionPane(
          motion: ScrollMotion(),
          // A pane can dismiss the Slidable.
          dismissible: DismissiblePane(onDismissed: () {
            onDelete(userData);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Data is deleted')));
          }),
          children: [
            SlidableAction(
              onPressed: (context) {
                onDelete(userData);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Please wait Data is getting deleted')));
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ]
      ),
      child: Card(
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: IntrinsicHeight(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(Utils.isEmpty(userData.name), style: boldStyle  ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        this.onEdit(userData);
                      },
                      child: Icon(
                        Icons.edit
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: RichText(
                          text: TextSpan(
                            text: "Gender " ,
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: Utils.getGender(userData.gender), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: RichText(
                          text: TextSpan(
                            text: "Weight " ,
                            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal,color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(text: Utils.isEmpty(userData.weight.toString()), style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.black)),
                            ],
                          ),
                        ),
                      ),
                     // Flexible(fit: FlexFit.tight, child: SizedBox()),
                      Expanded(
                          child: Text(Utils.isEmpty(userData.date.toString()), style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal,),textAlign: TextAlign.end)),
                    ],
                  ),
                )

              ],
            ),
          )),
    );
  }


}
